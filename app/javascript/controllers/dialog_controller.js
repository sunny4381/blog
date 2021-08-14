import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.clickHandler = (ev) => this.open(ev)
    this.element.addEventListener("click", this.clickHandler)
  }

  disconnect() {
    if (this.clickHandler) {
      this.element.removeEventListener("click", this.clickHandler)
    }
    this.clickHandler = null
    this.dialog = null
  }

  open(ev) {
    const href = ev.target.href
    if (! href) {
      return
    }

    fetch(href)
      .then(response => response.text())
      .then(html => this.openDialog(html))
      .catch(err => this.showError(err))

    ev.preventDefault()
    return false
  }

  openDialog(html) {
    this.dialog = UIkit.modal.dialog(html)
  }

  showError(err) {
    UIkit.modal.alert("Error")
  }
}
