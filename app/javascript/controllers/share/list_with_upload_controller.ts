import { Controller } from "stimulus"

declare const UIkit: any

export default class extends Controller {
  static override values = { url: String }

  urlValue?: string
  table: HTMLTableElement | null = null
  fileElementMap = new WeakMap()
  currentFile: File | null = null
  currentRow: HTMLTableRowElement | null = null
  currentProgressBar: HTMLProgressElement | null = null

  override connect() {
    if (! this.urlValue) {
      throw `data-${this.identifier}-url-value is not specified`
    }

    this.table = this.element.querySelector<HTMLTableElement>('.uk-table')

    UIkit.upload('.sophon-upload', {
      url: this.urlValue,
      multiple: true,
      name: "model[files][]",
      params: { authenticity_token: this.authenticityToken() },
      beforeAll: (uikitComponent: any, fileList: FileList) => {
        this.appendNewFiles(fileList)
      },
      beforeSend: (environment: { data: FormData, method: string, headers: any, xhr: XMLHttpRequest, responseType: string }) => {
        this.initializeCurrentUpload(environment.data)
      },
      error: () => {
        this.showError()
        this.finalizeCurrentUpload()
      },
      complete: (_xhr: XMLHttpRequest) => {
        this.showCompletion()
        this.finalizeCurrentUpload()
      },
      load: (ev: ProgressEvent) => { this.updateProgressBar(ev) },
      loadStart: (ev: ProgressEvent) => { this.updateProgressBar(ev) },
      progress: (ev: ProgressEvent) => { this.updateProgressBar(ev) },
      loadEnd: (ev: ProgressEvent) => { this.updateProgressBar(ev) },
      completeAll: (_xhr: XMLHttpRequest) => {
        // location.href = xhr.responseURL;
        // alert('Upload Completed');
      }
    })
  }

  override disconnect() {
  }

  authenticityToken() {
    return document.querySelector<HTMLMetaElement>("[name='csrf-token']")?.content
  }

  appendNewFiles(fileList: FileList) {
    for (let i = 0; i < fileList.length; i++) {
      const file = fileList.item(i)
      if (!file) {
        continue
      }

      const tr = document.createElement("tr")
      tr.innerHTML = `<td><span uk-icon="file"></span>${file.name}</td><td colspan="3"><progress class="uk-progress" value="0" max="100" hidden></progress><div class="uk-alert" uk-alert hidden></div></td>`
      this.fileElementMap.set(file, tr)
      this.table?.querySelector("tbody")?.appendChild(tr)
    }
  }

  initializeCurrentUpload(data: FormData) {
    const value = data.get("model[files][]")
    if (value) {
      this.currentFile = value as File
    } else {
      this.currentFile = null
    }

    if (this.currentFile) {
      const row = this.fileElementMap.get(this.currentFile)
      if (row) {
        this.currentRow = row as HTMLTableRowElement
      } else {
        this.currentRow = null;
      }
    }

    if (this.currentRow) {
      this.currentProgressBar = this.currentRow.querySelector<HTMLProgressElement>("progress")
    } else {
      this.currentProgressBar = null;
    }
  }

  finalizeCurrentUpload() {
    this.currentFile = null
    this.currentRow = null;
    this.currentProgressBar = null;
  }

  updateProgressBar(ev: ProgressEvent) {
    if (! this.currentProgressBar) {
      return
    }

    this.currentProgressBar.max = ev.total;
    this.currentProgressBar.value = ev.loaded;

    if (this.currentProgressBar.hasAttribute("hidden")) {
      this.currentProgressBar.removeAttribute("hidden")
    }
  }

  showCompletion() {
    if (!this.currentRow) {
      return
    }

    const messageElement = this.currentRow.querySelector<HTMLDivElement>(".uk-alert")
    if (!messageElement) {
      return
    }

    messageElement.innerHTML = `アップロードしました。<a href="${location.href}" title="再読み込み">再読み込みするにはここをクリック</a>してください。`
    // messageElement.classList.add("uk-alert-success")
    messageElement.removeAttribute('hidden')

    if (this.currentProgressBar) {
      this.currentProgressBar.setAttribute('hidden', 'hidden')
    }
  }

  showError() {
    if (!this.currentRow) {
      return
    }

    const messageElement = this.currentRow.querySelector<HTMLDivElement>(".uk-alert")
    if (!messageElement) {
      return
    }

    messageElement.innerText = "upload error"
    messageElement.classList.add("uk-alert-warning")
    messageElement.removeAttribute('hidden')
  }
}
