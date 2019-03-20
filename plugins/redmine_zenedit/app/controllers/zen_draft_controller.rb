class ZenDraftController < ApplicationController
  before_action :build_issue_from_params
  before_action :restore_issue, only: :create

  #<PRO>
  def show
    @issue = draft.try(:restore)
    render json: @issue.attributes.merge(notes: @issue.notes)
  end

  def create
    return unless @issue.save_draft
    render json: { status: 200 }, status: 200
  end

  def destroy
    return unless draft.destroy
    render json: { status: 200 }, status: 200
  end
  #</PRO>

  private

  def build_issue_from_params
    @issue = Issue.new
    @issue.id = unsafe_params['issue']['id']
    @issue.safe_attributes = (unsafe_params['issue'] || {}).deep_dup
    @issue.project_id = unsafe_params['issue']['project_id']
  end

  def unsafe_params
    if params.respond_to?(:to_unsafe_h)
      params.to_unsafe_h
    else
      params
    end
  end

  def draft
    @draft ||= @issue.last_draft
  end

  def restore_issue
    @issue = from_draft if draft

    if params['issue']['notes']
      @issue.init_journal(User.current)
      @issue.notes = params['issue']['notes']
    else
      @issue.notes = nil
    end
    @issue
  end

  def from_draft
    draft.restore.tap do |from_draft|
      from_draft.assign_attributes((unsafe_params['issue'] || {}).deep_dup)
      from_draft.id = @issue.id
    end
  end
end
