import { Controller } from "stimulus"

export default class extends Controller {
  open(ev) {
    const href = ev.target.href
    if (! href) {
      return
    }

    fetch(href)
      .then(response => response.text())
      .then(html => this.openDialog(html))
      .catch(err => this.showError(err))

    const dropDown = ev.target.closest("[uk-dropdown]")
    if (dropDown) {
      UIkit.dropdown(dropDown).hide(false);
    }

    ev.preventDefault()
    return false
  }

  openDialog(html) {
    UIkit.modal.dialog(html)
  }

  showError(err) {
    UIkit.modal.alert("Error")
  }
}
