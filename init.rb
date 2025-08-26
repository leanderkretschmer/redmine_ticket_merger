require 'redmine'

Redmine::Plugin.register :redmine_ticket_merger do
  name 'Redmine Ticket Merger'
  author 'Leander Kretschmer'
  description 'Ermöglicht das Zusammenführen von Tickets in Redmine'
  version '2.6.1'
  url 'https://github.com/leanderkretschmer/redmine_ticket_merger'
  author_url 'https://github.com/leanderkretschmer'
  requires_redmine version_or_higher: '6.0.0'
  
  # Berechtigungen definieren
  permission :merge_issues, {
    :issues => [:merge_form, :merge, :search_target_issues]
  }, :require => :member
end

# Patches laden
require_relative 'lib/redmine_ticket_merger/patches/issues_controller_patch'
require_relative 'lib/redmine_ticket_merger/patches/issues_helper_patch'
require_relative 'lib/redmine_ticket_merger/patches/application_helper_patch'
require_relative 'lib/redmine_ticket_merger/patches/context_menus_controller_patch'

