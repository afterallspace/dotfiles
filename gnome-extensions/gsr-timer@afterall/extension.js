import GObject from 'gi://GObject'
import GLib from 'gi://GLib'
import Gio from 'gi://Gio'
import St from 'gi://St'
import Clutter from 'gi://Clutter'

import * as Main from 'resource:///org/gnome/shell/ui/main.js'
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js'
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js'

const SCRIPT = GLib.build_filenamev([GLib.get_home_dir(), '.config', 'scripts', 'gsr-toggle.sh'])
const RUNDIR = GLib.get_user_runtime_dir()
const PIDFILE = `${RUNDIR}/gsr-toggle.pid`
const STARTFILE = `${RUNDIR}/gsr-toggle.start`

// The kernel truncates comm to 15 chars, so match against the truncated name.
const COMM = 'gpu-screen-reco'

// GNOME's orange portal indicator, shown while the screen is being captured.
// Matched by shell theme class rather than a private field name, to avoid
// depending on the internals of a specific GNOME version.
const NATIVE_CLASS = 'screen-sharing-indicator'

function readText(path) {
  try {
    const [ok, bytes] = GLib.file_get_contents(path)
    return ok ? new TextDecoder().decode(bytes).trim() : null
  } catch {
    return null
  }
}

/** PID of the recorder that is actually writing, or null. Dead and foreign pids are dropped. */
function recordingPid() {
  const pid = readText(PIDFILE)
  if (!pid || !/^\d+$/.test(pid)) return null
  return readText(`/proc/${pid}/comm`) === COMM ? pid : null
}

/**
 * The native stop icon ships in shell resources rather than the system icon
 * theme, so probe for it and fall back to the Adwaita equivalent.
 */
function stopIconName() {
  try {
    if (new St.IconTheme().has_icon('screencast-stop-symbolic')) return 'screencast-stop-symbolic'
  } catch {
    // St.IconTheme may be missing entirely — just take the fallback icon.
  }
  return 'media-playback-stop-symbolic'
}

function formatElapsed(ms) {
  const total = Math.max(0, Math.floor(ms / 1000))
  const s = String(total % 60).padStart(2, '0')
  const m = Math.floor(total / 60) % 60
  const h = Math.floor(total / 3600)
  return h > 0 ? `${h}:${String(m).padStart(2, '0')}:${s}` : `${m}:${s}`
}

const RecordingIndicator = GObject.registerClass(
  class RecordingIndicator extends PanelMenu.Button {
    _init() {
      // Third argument is dontCreateMenu: no menu needed, clicks are ours.
      super._init(0.5, 'GSR Recording Indicator', true)

      // The shell theme class gives exactly the native recording indicator's
      // look: red pill, bold white text, hover/active states, and correct
      // light/dark/high-contrast theming.
      this.add_style_class_name('screen-recording-indicator')

      // Scale the animation from the centre, or the pill drifts off by a corner.
      this.set_pivot_point(0.5, 0.5)
      this._shown = false

      const box = new St.BoxLayout({ y_align: Clutter.ActorAlign.CENTER })
      this._label = new St.Label({
        text: '0:00',
        y_align: Clutter.ActorAlign.CENTER,
      })
      box.add_child(this._label)
      box.add_child(new St.Icon({ icon_name: stopIconName() }))
      this.add_child(box)
    }

    // Any click stops the recording, matching GNOME's native indicator.
    vfunc_event(event) {
      const type = event.type()
      if (type === Clutter.EventType.BUTTON_PRESS || type === Clutter.EventType.TOUCH_BEGIN) {
        try {
          Gio.Subprocess.new([SCRIPT], Gio.SubprocessFlags.NONE)
        } catch (e) {
          logError(e, 'gsr-timer: failed to spawn gsr-toggle')
        }
        return Clutter.EVENT_STOP
      }
      return Clutter.EVENT_PROPAGATE
    }

    setElapsed(text) {
      this._label.text = text
    }

    /** Fade in and out instead of flipping visible outright. */
    setShown(shown) {
      if (shown === this._shown) return
      this._shown = shown

      this.remove_all_transitions()

      if (shown) {
        this.visible = true
        this.opacity = 0
        this.scale_x = 0.8
        this.scale_y = 0.8
        this.ease({
          opacity: 255,
          scale_x: 1,
          scale_y: 1,
          duration: 250,
          mode: Clutter.AnimationMode.EASE_OUT_BACK,
        })
      } else {
        this.ease({
          opacity: 0,
          scale_x: 0.8,
          scale_y: 0.8,
          duration: 200,
          mode: Clutter.AnimationMode.EASE_OUT_QUAD,
          onComplete: () => {
            this.visible = false
          },
        })
      }
    }
  },
)

export default class GsrTimerExtension extends Extension {
  enable() {
    this._suppressed = new Map()

    this._ticks = 0
    this._indicator = new RecordingIndicator()
    this._indicator.visible = false
    Main.panel.addToStatusArea(this.uuid, this._indicator, 0, 'right')

    // 250 ms rather than one second: polling once a second left the displayed
    // value trailing the real one by a random fraction, which at startup read
    // as a timer stuck for a couple of seconds.
    this._tick()
    this._timer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 250, () => {
      this._tick()
      return GLib.SOURCE_CONTINUE
    })
  }

  disable() {
    if (this._timer) {
      GLib.source_remove(this._timer)
      this._timer = null
    }
    for (const [actor, id] of this._suppressed) {
      actor.disconnect(id)
      actor.show()
    }
    this._suppressed.clear()
    this._suppressed = null

    this._indicator?.destroy()
    this._indicator = null
  }

  /**
   * Hides the native portal indicator. It is created lazily, after capture has
   * already started, so the panel tree is rewalked on every tick and each actor
   * found gets a notify::visible hook — otherwise GNOME shows it again.
   */
  _suppressNative() {
    const visit = (actor) => {
      const cls = actor.style_class
      if (typeof cls === 'string' && cls.includes(NATIVE_CLASS)) {
        if (!this._suppressed.has(actor)) {
          const id = actor.connect('notify::visible', () => {
            if (actor.visible) actor.hide()
          })
          this._suppressed.set(actor, id)
          actor.connect('destroy', () => this._suppressed.delete(actor))
        }
        if (actor.visible) actor.hide()
        return
      }
      for (const child of actor.get_children?.() ?? []) visit(child)
    }
    visit(Main.panel)
  }

  _tick() {
    // Walking the panel tree costs noticeably more than reading two small
    // files, so do it once a second rather than on every tick.
    if (this._ticks++ % 4 === 0) this._suppressNative()

    // A live process is not enough: while the user picks a source in the portal
    // dialog the recorder is already running but nothing is being captured. The
    // script stamps the start file only once capture begins, so wait for that —
    // otherwise the indicator would appear early and lie about elapsed time.
    const started = Number(readText(STARTFILE))
    const recording = recordingPid() !== null && Number.isFinite(started) && started > 0

    this._indicator.setShown(recording)
    if (!recording) return

    this._indicator.setElapsed(formatElapsed(Date.now() - started))
  }
}
