module RedmineZenedit
  module Patches
    module TextileHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :wikitoolbar_for_without_zenedit, :wikitoolbar_for
          alias_method :wikitoolbar_for, :wikitoolbar_for_with_zenedit
        end
      end

      module InstanceMethods
        def autocomplete_path
          # <PRO>
          return zenedit_users_autocomplete_path(id: params[:id], project_id: params[:project_id])
          # </PRO>
          ''
        end

        def original_method_call(field_id, path)
          if self.method(:wikitoolbar_for_without_zenedit).arity == 2
            wikitoolbar_for_without_zenedit(field_id, path)
          else
            wikitoolbar_for_without_zenedit(field_id)
          end
        end

        def wikitoolbar_for_with_zenedit(field_id, path=nil)
          heads_for_zenedit
          original_method_call(field_id, path) +
            javascript_tag(<<-JS)
              new jsZenEdit(
                document.getElementById('#{field_id}'),
                '#{escape_javascript "Zen"}',
                '#{escape_javascript l(:label_zen_placeholder)}',
                '#{zen_preview_path(id: params[:id])}',
                '#{autocomplete_path}'
              );
            JS
        end

        def heads_for_zenedit
          unless @heads_for_zenedit_included
            content_for :header_tags do
              javascript_include_tag(:zenedit, plugin: 'redmine_zenedit') +
              stylesheet_link_tag(:zenedit, plugin: 'redmine_zenedit')
            end
            @heads_for_zenedit_included = true
          end
        end
      end
    end
  end
end

unless Redmine::WikiFormatting::Textile::Helper.included_modules.include?(RedmineZenedit::Patches::TextileHelperPatch)
  Redmine::WikiFormatting::Textile::Helper.send(:include, RedmineZenedit::Patches::TextileHelperPatch)
end
