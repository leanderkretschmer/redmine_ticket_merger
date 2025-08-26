# Routes für das Ticket Merger Plugin registrieren
# Diese Datei wird nach der Plugin-Initialisierung geladen

Rails.application.routes.append do
  resources :issues, :only => [] do
    member do
      get :merge_form
      post :merge
      get :search_target_issues
    end
  end
end
