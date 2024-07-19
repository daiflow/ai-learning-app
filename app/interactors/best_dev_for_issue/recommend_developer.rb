# frozen_string_literal: true

module BestDevForIssue
  class RecommendDeveloper
    include Interactor::Organizer

    organize RetrieveSimilarDevelopmentIssues, PromptExecutor, CommentPromptResponseOnJira
  end
end
