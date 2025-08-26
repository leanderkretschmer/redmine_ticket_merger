module RedmineTicketMerger
  module Patches
    module ContextMenusControllerPatch
      def self.included(base)
        base.class_eval do
          # Kontextmenü für Issues erweitern
          def issues
            @issues = Issue.visible.where(:id => params[:ids]).to_a
            if (@issues.size == 1)
              @issue = @issues.first
            end
            
            @can = {:edit => @issues.collect{|c| c.editable?}.inject{|memo,word| memo && word},
                   :log_time => (@project && User.current.allowed_to?(:log_time, @project)),
                   :copy => User.current.allowed_to?(:add_issues, @project),
                   :delete => @issues.collect{|c| c.deletable?}.inject{|memo,word| memo && word}
                   }
            
            # Merge-Berechtigung hinzufügen
            @can[:merge] = @issues.size == 1 && 
                          User.current.allowed_to?(:merge_issues, @project) && 
                          !@issues.first.closed?
            
            @back = back_url
            
            render :layout => false
          end
        end
      end
    end
  end
end

# Patch anwenden
ContextMenusController.send(:include, RedmineTicketMerger::Patches::ContextMenusControllerPatch)
