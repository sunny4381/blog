import { Controller } from "stimulus"

export default class extends Controller {
  initialize() {
    if (! this.element.id) {
      throw "id isn't assigned"
    }
  }

  connect() {
    this.submitHandler = (ev) => this.submitForm(ev)
    this.element.addEventListener("submit", this.submitHandler)
  }

  disconnect() {
    if (this.submitHandler) {
      this.element.removeEventListener("submit", this.submitHandler)
    }
    this.submitHandler = null
  }

  submitForm(ev) {
    const formData = new FormData(this.element)

    fetch(this.element.action, { method: this.element.method || "post", body: formData })
      .then(response => this.renderSubmitResult(response))
      .catch(error => this.renderSubmitError(error))

    ev.preventDefault()
    return false;
  }

  renderSubmitResult(response) {
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
}
