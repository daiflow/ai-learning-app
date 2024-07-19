# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module Prompt
  class OllamaRunner
    def initialize(prompt_text)
      @server_host = ENV.fetch('OLLAMA_CHAT_SERVER_HOST', nil)
      @server_model = ENV.fetch('OLLAMA_CHAT_SERVER_MODEL', nil)
      @prompt = prompt_text
    end

    def self.call(prompt_text)
      new(prompt_text).call
    end

    def call
      uri = URI(server_host)
      request = Net::HTTP::Post.new(uri)
      configure_request(request)

      perform_request(request, uri)
    end

    private

    def perform_request(request, uri)
      Rails.logger.debug 'Executing prompt request...'
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.read_timeout = 720
        http.request(request)
      end
      parse_response(response)
    end

    def parse_response(response)
      response_object = JSON.parse(response.body)
      response_object['message']['content']
    end

    def configure_request(request)
      request.content_type = 'application/json'
      request.body = JSON.dump({
                                 model: server_model,
                                 messages: [
                                   {
                                     role: 'user',
                                     content: prompt
                                   }
                                 ],
                                 stream: false
                               })
    end

    attr_reader :server_host, :server_model, :prompt
  end
end
