import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  connect() {
    let backdrop = document.querySelector(".modal-backdrop");

    if (backdrop) {
      backdrop.remove();
    }

    this.modal = new window.bootstrap.Modal(this.element);
    this.modal.show();

    this.element.addEventListener("hidden.bs.modal", (event) => {
      this.element.remove();
    })
  }

  disconnect() {
    this.modal.hide();
  }
}
