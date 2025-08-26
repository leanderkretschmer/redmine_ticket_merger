module RedmineTicketMerger
  module Patches
    module ContextMenusControllerPatch
      def self.included(base)
        base.class_eval do
          # Merge-Berechtigung zum bestehenden Kontextmenü hinzufügen
          def issues
            # Bestehende Methode aufrufen
            super
            
            # Merge-Berechtigung hinzufügen
            if @can && @issues && @issues.size == 1
              @can[:merge] = User.current.allowed_to?(:merge_issues, @project) && !@issues.first.closed?
            end
          end
        end
      end
    end
  end
end

# Patch anwenden
ContextMenusController.send(:include, RedmineTicketMerger::Patches::ContextMenusControllerPatch)
