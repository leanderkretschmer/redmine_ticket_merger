require 'redmine'

Redmine::Plugin.register :redmine_ticket_merger do
  name 'Redmine Ticket Merger'
  author 'Leander Kretschmer'
  description 'Ermöglicht das Zusammenführen von Tickets in Redmine'
  version '2.5.0'
  url 'https://github.com/leanderkretschmer/redmine_ticket_merger'
  author_url 'https://github.com/leanderkretschmer'
  requires_redmine version_or_higher: '6.0.0'
  
  # Berechtigungen definieren
  permission :merge_issues, {
    :issues => [:merge_form, :merge]
  }, :require => :member
  
  # Menü hinzufügen
  menu :project_menu, :ticket_merger, { :controller => 'issues', :action => 'merge_form' }, 
       :caption => :label_merge_issues, :after => :issues, :param => :project_id
end

# Patches laden
require_relative 'lib/redmine_ticket_merger/patches/issues_controller_patch'

# Routes registrieren
ActionDispatch::Routing::Mapper.class_eval do
  def draw_redmine_ticket_merger_routes
    resources :projects do
      resources :issues, :only => [] do
        collection do
          get :merge_form
          post :merge
        end
      end
    end
  end
end

# Routes nach der Plugin-Registrierung hinzufügen
Rails.application.routes.draw do
  draw_redmine_ticket_merger_routes
end

