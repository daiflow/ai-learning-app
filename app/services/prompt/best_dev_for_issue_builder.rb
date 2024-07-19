# frozen_string_literal: true

module Prompt
  class BestDevForIssueBuilder
    PROMPT_PATH = 'prompts/best_dev_for_issue_v2.txt.erb'

    def initialize(issue_list, key, title, description)
      @issue_list = issue_list
      @key = key
      @title = title
      @description = description
    end

    def self.call(issue_list, key, title, description)
      new(issue_list, key, title, description).call
    end

    def call
      erb = erb_template
      result = erb.result(binding)
      local_output_path = output_path
      File.write(local_output_path, result)
      Rails.logger.debug { "Prompt generated file: #{local_output_path}" }
      [result, local_output_path]
    end

    private

    attr_reader :issue_list, :key, :title, :description

    def erb_template
      ERB.new(Rails.root.join(PROMPT_PATH).read)
    end

    def output_path
      # "/tmp/#{Time.zone.today.strftime('%Y-%m-%d')}_best_dev_for_issue_#{Time.zone.now.to_i}.txt"
      "/tmp/#{Time.zone.today.strftime('%Y-%m-%d')}_best_dev_for_issue.txt"
    end
  end
end
