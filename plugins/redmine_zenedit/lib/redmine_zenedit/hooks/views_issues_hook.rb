module RedmineZenedit
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_top, partial: 'issues/draft'
    end
  end
end
