# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
    def index
      # Renderiza el archivo HTML principal de tu aplicación
      render file: Rails.root.join('public', 'index.html'), layout: false
    end
  
    def serve_css
      # Ruta para servir archivos CSS
      send_file Rails.root.join('app', 'assets', 'stylesheets', params[:filename])
    end
  
    def serve_js
      # Ruta para servir archivos JS
      send_file Rails.root.join('app', 'javascript', params[:filename])
    end
  end
  