import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js'
import * as Main from 'resource:///org/gnome/shell/ui/main.js'

// What goes between the date and the time; ', ' gives "Oct 10, 6:35 PM".
const SEPARATOR = ' · '

// The wall clock joins date and time with an EN SPACE, and the 12-hour %l pads
// single-digit hours with a FIGURE SPACE, so the top bar showed a hole about
// two characters wide that shrank again from 10:00. \s covers both.
const GAP = /\s* \s*/
const PAD = / /g

export default class PanelClock extends Extension {
  enable() {
    this._dateMenu = Main.panel.statusArea.dateMenu
    this._label = this._dateMenu._clockDisplay
    // The date menu binds the wall clock straight to the label, so rewrite the
    // text every time the binding pushes a new value.
    this._label.connectObject('notify::text', () => this._rewrite(), this)
    this._rewrite()
  }

  _rewrite() {
    const text = this._label.text
    const fixed = text.replace(GAP, SEPARATOR).replace(PAD, '')
    if (fixed !== text) this._label.text = fixed
  }

  disable() {
    this._label.disconnectObject(this)
    this._label.text = this._dateMenu._clock.clock
    this._label = null
    this._dateMenu = null
  }
}
