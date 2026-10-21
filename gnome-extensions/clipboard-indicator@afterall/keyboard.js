import Clutter from 'gi://Clutter'
import GLib from 'gi://GLib'
import * as Main from 'resource:///org/gnome/shell/ui/main.js'

export class Keyboard {
  #device
  #contentPurpose

  constructor() {
    // GNOME 51 removed Clutter.get_default_backend(), the backend now hangs off the stage context.
    const seat = global.stage.context.get_backend().get_default_seat()
    this.#device = seat.create_virtual_device(Clutter.InputDeviceType.KEYBOARD_DEVICE)

    Main.inputMethod.connectObject(
      'notify::content-purpose',
      (method) => {
        this.#contentPurpose = method.content_purpose
      },
      this,
    )
  }

  destroy() {
    Main.inputMethod.disconnectObject(this)
    this.#device.run_dispose()
  }

  #notify(key, state) {
    // Keys are sent from a timeout, where there is no current event and
    // Clutter.get_current_event_time() is 0. notify_keyval() wants microseconds
    // on the monotonic clock, which is what real input devices report.
    this.#device.notify_keyval(GLib.get_monotonic_time(), key, state)
  }

  get purpose() {
    return this.#contentPurpose
  }

  press(key) {
    this.#notify(key, Clutter.KeyState.PRESSED)
  }

  release(key) {
    this.#notify(key, Clutter.KeyState.RELEASED)
  }
}
