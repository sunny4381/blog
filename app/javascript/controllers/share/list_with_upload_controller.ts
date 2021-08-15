import { Controller } from "stimulus"

declare var UIkit: any

export default class extends Controller {
  static values = { url: String }

  urlValue?: string

  progressBar: HTMLProgressElement | null = null

  connect() {
    if (! this.urlValue) {
      throw `data-${this.identifier}-url-value is not specified`
    }

    this.progressBar = this.element.querySelector<HTMLProgressElement>('#sophon-upload-progressbar')

    UIkit.upload('.sophon-upload', {
      url: this.urlValue,
      multiple: true,
      name: "model[files][]",
      params: { authenticity_token: this.authenticityToken() },
      loadStart: (ev: ProgressEvent) => { this.showProgressBar(); this.updateProgressBar(ev) },
      progress: (ev: ProgressEvent) => this.updateProgressBar(ev),
      loadEnd: (ev: ProgressEvent) => { this.updateProgressBar(ev); this.hideProgressBar() },
      completeAll: function (xhr: XMLHttpRequest) {
        // location.href = xhr.responseURL;
        alert('Upload Completed');
      }
    })
  }

  disconnect() {
    console.log("disconnect")
  }

  authenticityToken() {
    return document.querySelector<HTMLMetaElement>("[name='csrf-token']")?.content
  }

  showProgressBar() {
    if (this.progressBar) {
      this.progressBar.removeAttribute('hidden')
    }
  }

  hideProgressBar() {
    if (this.progressBar) {
      this.progressBar.setAttribute('hidden', 'hidden')
    }
  }

  updateProgressBar(ev: ProgressEvent) {
    if (this.progressBar) {
      this.progressBar.max = ev.total;
      this.progressBar.value = ev.loaded;
    }
  }
}
