import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 3000 } }

  connect() {
    this.timer = setTimeout(() => this.close(), this.timeoutValue)
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  close() {
    this.element.classList.add("flash--fade")
    this.element.addEventListener("animationend", () => this.element.remove())
  }
}
