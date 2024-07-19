# frozen_string_literal: true

module BestDevForIssue
  class PromptExecutor < ApplicationInteractor
    def call
      if check_invalid_conditions
        store_missing_parameter_error
        return
      end

      prompt, = Prompt::BestDevForIssueBuilder.call(
        context.similar_issues, context.key, context.title, context.description
      )
      context.prompt = prompt

      execute_prompt(prompt)
    end

    private

    def execute_prompt(prompt)
      context.prompt_response = if context.prompt_provider == 'openai'
                                  Prompt::OpenaiRunner.call(prompt)
                                else
                                  Prompt::OllamaRunner.call(prompt)
                                end
    end

    def check_invalid_conditions
      context.similar_issues.blank? || context.key.blank? || context.title.blank? || context.key.blank? || context.prompt_provider.blank?
    end
  end
end
