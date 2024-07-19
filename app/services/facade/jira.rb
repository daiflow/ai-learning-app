# frozen_string_literal: true

module Facade
  class Jira
    def initialize
      api_token = ENV.fetch('JIRA_API_TOKEN', nil)
      options = {
        username: ENV.fetch('JIRA_USERNAME', nil),
        password: api_token,
        site: ENV.fetch('JIRA_SITE', nil),
        context_path: '',
        auth_type: :basic
      }
      @client = JIRA::Client.new(options)
    end

    def self.comment_on_jira_issue(issue_key, comment)
      new.comment_on_jira_issue(issue_key, comment)
    end

    def comment_on_jira_issue(issue_key, comment)
      issue = client.Issue.find(issue_key)
      comment_obj = issue.comments.build
      comment_obj.save!(body: comment)
    end

    private

    attr_reader :client
  end
end
