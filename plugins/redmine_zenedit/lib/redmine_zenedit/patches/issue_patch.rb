module RedmineZenedit
  module Patches
    module IssuePatch
      def self.included(base)
        base.rcrm_acts_as_draftable parent: :project
        base.class_eval do
          # <PRO>
          include RedmineZenedit::Helper
          include InstanceMethods

          alias_method :notified_users_without_zen_mentions, :notified_users
          alias_method :notified_users, :notified_users_with_zen_mentions
          # </PRO>
        end
      end

      module InstanceMethods
        # <PRO>
        def notified_users_with_zen_mentions
          if current_journal
            text = current_journal.notes.to_s
            journal_detail = current_journal.details.last
            text += " #{journal_detail.value}" if journal_detail.try(:prop_key) == 'description'
          else
            text = description
          end

          mentioned_users = User.where(login: find_mentions(text)).to_a
          mentioned_users.reject! { |user| !visible?(user) } # Remove users that can not view the issue

          (notified_users_without_zen_mentions + mentioned_users).uniq
        end
        # </PRO>
      end
    end
  end
end

unless Issue.included_modules.include?(RedmineZenedit::Patches::IssuePatch)
  Issue.send(:include, RedmineZenedit::Patches::IssuePatch)
end
