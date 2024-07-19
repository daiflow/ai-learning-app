# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module Prompt
  class OpenaiRunner
    def initialize(prompt_text)
      @client = OpenAI::Client.new do |f|
        f.response :logger, Logger.new($stdout), bodies: true
      end
      @prompt = prompt_text
    end

    def self.call(prompt_text)
      new(prompt_text).call
    end

    def call
      Rails.logger.debug 'Executing prompt request...'
      response = client.chat(
        parameters: {
          model: 'gpt-4o',
          messages: [
            { role: 'user', content: prompt }
          ],
          temperature: 0.3,
          stream: false
        }
      )
      response.dig('choices', 0, 'message', 'content')
    end

    private

    attr_reader :client, :prompt
  end
end
