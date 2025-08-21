# Routes für das Ticket Merger Plugin registrieren
# Diese Datei wird nach der Plugin-Initialisierung geladen

Rails.application.routes.draw do
  resources :projects do
    resources :issues, :only => [] do
      collection do
        get :merge_form
        post :merge
      end
    end
  end
end
