import Gio from 'gi://Gio'
import GLib from 'gi://GLib'
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js'

// Apps that hide into a tray icon when their window is closed, by Wayland app
// id. With no tray in GNOME they would linger in memory unseen until logout.
const APPS = ['mullvad-vpn']

// Seconds to wait before ending the process, so an app that quits on its own or
// swaps one window for another is left alone.
const GRACE = 2

export default class TraylessQuit extends Extension {
  enable() {
    this._timeouts = new Set()
    global.display.connectObject('window-created', (_display, win) => this._watch(win), this)
    for (const actor of global.get_window_actors()) this._watch(actor.meta_window)
  }

  _watch(win) {
    win.connectObject('unmanaged', () => APPS.includes(win.get_wm_class()) && this._schedule(win.get_pid()), this)
  }

  _schedule(pid) {
    const id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, GRACE, () => {
      this._timeouts.delete(id)
      const shown = global.get_window_actors().some((actor) => actor.meta_window.get_pid() === pid)
      if (!shown && GLib.file_test(`/proc/${pid}`, GLib.FileTest.EXISTS))
        Gio.Subprocess.new(['kill', String(pid)], Gio.SubprocessFlags.NONE)
      return GLib.SOURCE_REMOVE
    })
    this._timeouts.add(id)
  }

  disable() {
    global.display.disconnectObject(this)
    for (const actor of global.get_window_actors()) actor.meta_window.disconnectObject(this)
    for (const id of this._timeouts) GLib.source_remove(id)
    this._timeouts = null
  }
}
