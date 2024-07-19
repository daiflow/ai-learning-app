client = OpenAI::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
end

response = client.embeddings(
  parameters: {
    model: "text-embedding-ada-002",
    input: "Test"
  }
)

puts response.dig("data", 0, "embedding")