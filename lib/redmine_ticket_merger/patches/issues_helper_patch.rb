module RedmineTicketMerger
  module Patches
    module IssuesHelperPatch
      def self.included(base)
        base.class_eval do
          # Kontextmenü-Option für Merge hinzufügen
          def render_issue_merge_context_menu(issue)
            return unless User.current.allowed_to?(:merge_issues, issue.project)
            return if issue.closed?
            
            content_tag(:li, class: 'merge-issue-option') do
              link_to(l(:label_merge_issue), '#', 
                      class: 'merge-issue-link',
                      data: { 
                        issue_id: issue.id,
                        project_id: issue.project.id,
                        remote: true
                      })
            end
          end
        end
      end
    end
  end
end

# Patch anwenden
IssuesHelper.send(:include, RedmineTicketMerger::Patches::IssuesHelperPatch)
