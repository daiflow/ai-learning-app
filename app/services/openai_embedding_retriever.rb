# frozen_string_literal: true

class OpenaiEmbeddingRetriever
  def initialize(text)
    @text = text
    @openai_client = OpenAI::Client.new do |f|
      f.response :logger, Logger.new($stdout), bodies: true
    end
  end

  def self.call(text)
    new(text).call
  end

  def call
    response = openai_client.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: text
      }
    )
    response.dig('data', 0, 'embedding')
  end

  private

  attr_reader :text, :openai_client
end
