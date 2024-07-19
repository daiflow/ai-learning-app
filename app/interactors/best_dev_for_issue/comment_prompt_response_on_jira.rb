# frozen_string_literal: true

module BestDevForIssue
  class CommentPromptResponseOnJira < ApplicationInteractor
    def call
      if check_invalid_conditions
        store_missing_parameter_error
        return
      end

      Facade::Jira.comment_on_jira_issue(context.key, context.prompt_response)
      context.comment_time_on_jira = Time.zone.now.to_s
      context.comment_on_jira = true
    end

    private

    def check_invalid_conditions
      context.prompt.blank? || context.prompt_response.blank? || context.key.blank?
    end
  end
end
