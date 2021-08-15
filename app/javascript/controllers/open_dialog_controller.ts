import { Controller } from "stimulus"

declare var UIkit: any

export default class extends Controller {
  private dialog: any

  clickHandler = (ev: Event) => {
    this.open(ev)
  }

  connect() {
    this.element.addEventListener("click", this.clickHandler)
  }

  disconnect() {
    if (this.clickHandler) {
      this.element.removeEventListener("click", this.clickHandler)
    }
    this.dialog = null
  }

  open(ev: Event) {
    if (! ev.target) {
      return
    }

    const target = ev.target as HTMLAnchorElement
    const href = target.href
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

  openDialog(html: string) {
    this.dialog = UIkit.modal.dialog(html)
  }

  showError(_err: Response) {
    UIkit.modal.alert("Error")
  }
}
