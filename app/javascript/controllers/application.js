import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

// app/javascript/controllers/application_controller.js

import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    // Verifica si el controlador está en la página de inicio y monta el componente FeaturesList
    if (document.body.dataset.controller === 'pages--index') {
      import('../components/FeaturesList').then(({ default: FeaturesList }) => {
        new FeaturesList().mount();
      });
    }
  }
}
