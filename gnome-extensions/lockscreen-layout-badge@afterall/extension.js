import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js'
import { getInputSourceManager } from 'resource:///org/gnome/shell/ui/status/keyboard.js'
import * as Main from 'resource:///org/gnome/shell/ui/main.js'

const LABELS = {
  us: '🇺🇸',
  ru: '🇷🇺',
}

export default class LockscreenLayoutBadge extends Extension {
  enable() {
    // session-modes lists unlock-dialog, so disable() is not called on lock
    // and the badges survive onto the lock screen.
    this._ism = getInputSourceManager()
    this._original = new Map()
    this._sourceSignals = new Map()
    this._sourcesChangedId = this._ism.connect('sources-changed', () => this._applyAll())
    this._applyAll()
  }

  _applyAll() {
    for (const [source, id] of this._sourceSignals) source.disconnect(id)
    this._sourceSignals.clear()

    for (const i in this._ism.inputSources) {
      const source = this._ism.inputSources[i]
      this._apply(source)
      // reapply if someone else's disable() restores the stock shortName
      const id = source.connect('changed', () => this._apply(source))
      this._sourceSignals.set(source, id)
    }

    this._pinWidth()
  }

  // On layout switch the indicator's width recalc drifts by a subpixel and
  // nudges neighbouring icons. CSS cannot fix it: both the indicator container
  // and the panel button override the width vfunc and ignore styled width.
  // Pinning the allocation in Clutter wins, since set_width() beats any vfunc.
  _pinWidth() {
    const button = Main.panel.statusArea.keyboard
    if (!button) return
    button.set_width(-1) // unpin first, to measure the natural width
    const [, natural] = button.get_preferred_width(-1)
    button.set_width(Math.ceil(natural))
  }

  _apply(source) {
    const label = LABELS[source.id]
    if (!label || source.shortName === label) return
    if (!this._original.has(source.id)) this._original.set(source.id, source.shortName)
    source.shortName = label // the setter refreshes the indicator and OSD itself
  }

  disable() {
    // Only runs when the extension is genuinely disabled, not on screen lock
    // (see session-modes).
    this._ism.disconnect(this._sourcesChangedId)
    for (const [source, id] of this._sourceSignals) source.disconnect(id)
    this._sourceSignals.clear()

    for (const i in this._ism.inputSources) {
      const source = this._ism.inputSources[i]
      if (this._original.has(source.id)) source.shortName = this._original.get(source.id)
    }
    Main.panel.statusArea.keyboard?.set_width(-1)
    this._original = null
    this._ism = null
  }
}
