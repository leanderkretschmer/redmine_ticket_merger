module RedmineTicketMerger
  module Patches
    module ApplicationHelperPatch
      def self.included(base)
        base.class_eval do
          # Kontextmenü für Issues erweitern
          def render_issue_merge_context_menu(issue)
            return unless User.current.allowed_to?(:merge_issues, issue.project)
            return if issue.closed?
            
            content_tag(:li, class: 'merge-issue-option') do
              link_to(l(:label_merge_issue), merge_form_issue_path(issue), 
                      class: 'icon icon-merge')
            end
          end
        end
      end
    end
  end
end

# Patch anwenden
ApplicationHelper.send(:include, RedmineTicketMerger::Patches::ApplicationHelperPatch)
