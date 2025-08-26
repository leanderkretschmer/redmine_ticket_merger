module RedmineTicketMerger
  module Patches
    module ContextMenusHelperPatch
      def self.included(base)
        base.class_eval do
          # Kontextmenü für Issues erweitern
          def render_issues_context_menu(issues)
            return '' if issues.empty?
            
            # Bestehende Kontextmenü-Links
            links = []
            links << context_menu_link(l(:button_edit), {:controller => 'issues', :action => 'bulk_edit', :ids => issues.map(&:id)}, :class => 'icon icon-edit', :disabled => !issues.collect{|c| c.editable?}.inject{|memo,word| memo && word})
            links << context_menu_link(l(:button_copy), {:controller => 'issues', :action => 'new', :ids => issues.map(&:id), :copy => 1}, :class => 'icon icon-copy', :disabled => !User.current.allowed_to?(:add_issues, @project))
            links << context_menu_link(l(:button_delete), {:controller => 'issues', :action => 'destroy', :ids => issues.map(&:id)}, :method => :delete, :class => 'icon icon-del', :disabled => !issues.collect{|c| c.deletable?}.inject{|memo,word| memo && word}, :confirm => l(:text_issues_destroy_confirmation))
            
            # Merge-Link hinzufügen (nur bei einzelnen Issues)
            if issues.size == 1 && User.current.allowed_to?(:merge_issues, @project) && !issues.first.closed?
              links << context_menu_link(l(:label_merge_issue), {:controller => 'issues', :action => 'merge_form', :id => issues.first.id}, :class => 'icon icon-merge')
            end
            
            links.join("\n").html_safe
          end
        end
      end
    end
  end
end

# Patch anwenden
ContextMenusHelper.send(:include, RedmineTicketMerger::Patches::ContextMenusHelperPatch)
