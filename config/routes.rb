# Plugin Routes für Redmine Ticket Merger
resources :projects do
  resources :issues, :only => [] do
    collection do
      get :merge_form
      post :merge
    end
  end
end
