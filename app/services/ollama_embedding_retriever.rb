# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class OllamaEmbeddingRetriever
  def initialize(text)
    @text = text
    @server_host = ENV.fetch('OLLAMA_EMBEDDING_SERVER_HOST', nil)
    @embedding_model = ENV.fetch('OLLAMA_EMBEDDING_SERVER_MODEL', nil)
  end

  def self.call(text)
    new(text).call
  end

  def call
    uri = URI(server_host)
    response = perform_request_to_embedding_server(uri)
    parse_embedding_server_response(response)
  end

  private

  # output is a vector [0.15391048789024353, -0.3606295883655548, ... , 0.5862309336662292]
  def parse_embedding_server_response(response)
    JSON.parse(response.body)['embedding']
  end

  def perform_request_to_embedding_server(uri)
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = JSON.dump(
      {
        model: embedding_model,
        prompt: text,
        stream: false
      }
    )
    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.read_timeout = 10
      http.request(request)
    end
  end

  attr_reader :text, :server_host, :embedding_model
end
