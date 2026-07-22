import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  connect() {
    const bsAlert = new window.bootstrap.Alert(this.element)
    setTimeout(function () { bsAlert.close(); }, 3000);
  }
}
