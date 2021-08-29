import { Controller } from "stimulus"

declare const UIkit: any

export default class extends Controller {
  override initialize() {
    if (! this.element.id) {
      throw "id isn't assigned"
    }
  }

  submitHandler = (ev: Event) => this.submitForm(ev)

  override connect() {
    this.element.addEventListener("submit", this.submitHandler)
  }

  override disconnect() {
    this.element.removeEventListener("submit", this.submitHandler)
  }

  submitForm(ev: Event) {
    const form = this.element as HTMLFormElement
    const formData = new FormData(form)

    fetch(form.action, { method: form.method || "post", body: formData })
      .then(response => this.renderSubmitResult(response))
      .catch(error => this.renderSubmitError(error))

    ev.preventDefault()
    return false;
  }

  renderSubmitResult(response: Response) {
    if (response.redirected) {
      location.href = response.url
      return
    }

    response.text().then((html) => {
      if (! html) {
        return;
      }

      const fragment = document.createElement('div')
      fragment.innerHTML = html
      const newForm = fragment.querySelector("#" + this.element.id)
      if (newForm) {
        this.element.innerHTML = newForm.innerHTML
      } else {
        this.element.innerHTML = html
      }
    })
  }

  renderSubmitError(_error: Response) {
    UIkit.modal.alert("Error")
  }
}
