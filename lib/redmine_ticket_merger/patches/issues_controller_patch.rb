module RedmineTicketMerger
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.class_eval do
          # Neue Merge-Methoden hinzufügen
          def merge_form
            find_issue
            find_project
            authorize
            authorize_merge
            
            @issues = @project.issues.open.where.not(id: @issue.id).order(:id)
          end
          
          def merge
            find_issue
            find_project
            authorize
            authorize_merge
            
            to_issue_id = params[:to_issue_id]
            
            if to_issue_id.blank?
              flash[:error] = l(:error_select_target_issue)
              redirect_to issue_path(@issue)
              return
            end
            
            if @issue.id.to_s == to_issue_id
              flash[:error] = l(:error_cannot_merge_same_issue)
              redirect_to issue_path(@issue)
              return
            end
            
            begin
              handler = TicketMerger::Handler.new(@issue.id, to_issue_id)
              
              flash[:notice] = l(:notice_issues_merged_successfully, 
                                from: "##{@issue.id}", 
                                to: "##{to_issue_id}")
              
              redirect_to issue_path(to_issue_id)
              
            rescue => e
              flash[:error] = l(:error_merge_failed, message: e.message)
              redirect_to issue_path(@issue)
            end
          end
          
          def search_target_issues
            find_issue
            find_project
            authorize
            authorize_merge
            
            query = params[:q]
            if query.blank?
              render json: []
              return
            end
            
            # Suche nach Issues mit ID oder Betreff
            issues = @project.issues.open
              .where.not(id: @issue.id)
              .where("id = ? OR subject LIKE ?", query.to_i, "%#{query}%")
              .limit(10)
              .map { |issue| { id: issue.id, text: "##{issue.id} - #{issue.subject}" } }
            
            render json: issues
          end
          
          private
          
          def authorize_merge
            unless User.current.allowed_to?(:merge_issues, @project)
              render_403
            end
          end
        end
      end
    end
  end
end

# Patch anwenden
IssuesController.send(:include, RedmineTicketMerger::Patches::IssuesControllerPatch)
