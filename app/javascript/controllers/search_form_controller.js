import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  cleared(event) {
    if (event.target.value === "") {
      event.target.form?.requestSubmit()
    }
  }
}
