class IssuesController < ApplicationController
  before_action :find_project, :authorize, :except => [:index]
  before_action :find_issue, :only => [:merge_form, :merge]
  before_action :authorize_merge, :only => [:merge_form, :merge]
  
  def merge_form
    @issues = @project.issues.open.order(:id)
    @issue = @issues.find(params[:id]) if params[:id]
  end
  
  def merge
    from_issue_id = params[:from_issue_id]
    to_issue_id = params[:to_issue_id]
    
    if from_issue_id.blank? || to_issue_id.blank?
      flash[:error] = l(:error_select_both_issues)
      redirect_to merge_form_project_issues_path(@project)
      return
    end
    
    if from_issue_id == to_issue_id
      flash[:error] = l(:error_cannot_merge_same_issue)
      redirect_to merge_form_project_issues_path(@project)
      return
    end
    
    begin
      handler = TicketMerger::Handler.new(from_issue_id, to_issue_id)
      
      flash[:notice] = l(:notice_issues_merged_successfully, 
                        from: "##{from_issue_id}", 
                        to: "##{to_issue_id}")
      
      redirect_to issue_path(to_issue_id)
      
    rescue => e
      flash[:error] = l(:error_merge_failed, message: e.message)
      redirect_to merge_form_project_issues_path(@project)
    end
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def find_issue
    @issue = @project.issues.find(params[:id]) if params[:id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def authorize_merge
    unless User.current.allowed_to?(:merge_issues, @project)
      render_403
    end
  end
end
