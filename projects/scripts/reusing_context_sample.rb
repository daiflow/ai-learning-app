# frozen_string_literal: true

client = OpenAI::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
end

OpenAI.rough_token_count('Please, tell me the duration in minutes of the movie Rocky One')

response = client.chat(
  parameters: {
    model: 'gpt-3.5-turbo', # Required.
    messages: [{ role: 'user', content: 'Please, tell me the duration in minutes of the movie Rocky One' }], # Required.
    temperature: 0.7
  }
)
puts response.dig('choices', 0, 'message', 'content')

response = client.chat(
  parameters: {
    model: 'gpt-3.5-turbo-1106',
    response_format: { type: 'json_object' },
    messages: [{ role: 'user', content: "Please, tell me the duration in minutes of the movie Rocky One in a Json format. More specifically in the field 'duration'" }], # Required.
    temperature: 0.7
  }
)
puts response.dig('choices', 0, 'message', 'content')

##
# In the website version of ChatGPT, the contextual continuity is achieved through
# the resending of all prior messages for each new communication, ensuring the conversation
# maintains its coherence. However, it’s important to note that when interfacing with the API,
# the responsibility for managing and preserving conversation history rests upon the developer.
# To replicate similar functionality through the API, developers must structure their
# API requests as a sequence of messages within a conversation. Each message in this
# sequence encompasses a “role” (system, user, or assistant) and “content”
# (the text of the message). By incorporating all prior messages within the conversation
# history while making API requests, developers provide the model with the essential context
# to produce relevant responses

response = client.chat(
  parameters: {
    model: 'gpt-3.5-turbo-1106',
    response_format: { type: 'json_object' },
    messages: [
      { role: 'user',
        content: "Please, tell me the duration in minutes of the movie Rocky One . More specifically in the field 'duration'" }
    ], # Required.
    temperature: 0.7
  }
)
puts response.dig('choices', 0, 'message', 'content')

response = client.chat(
  parameters: {
    model: 'gpt-3.5-turbo', # Required.
    messages: [
      { role: 'user', content: 'Please, tell me the duration of Rocky One' },
      { role: 'assistant', content: 'The duration of the movie Rocky One is 119 minutes.' },
      { role: 'user', content: 'What about the Titanic?' }
    ], # Required.
    temperature: 0.7
  }
)
puts response.dig('choices', 0, 'message', 'content')


client = OpenAI::Client.new(
  uri_base: "https://oai.hconeai.com/",
  request_timeout: 240,
  extra_headers: {
    "X-Proxy-TTL" => "43200",
    "X-Proxy-Refresh": "true",
    "Helicone-Auth": "Bearer #{ENV.fetch('HELICONE_API_KEY')}",
    "helicone-stream-force-format" => "true",
  }
)


client = OpenAI::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
  f.uri_base = 'https://oai.hconeai.com/'
  f.extra_headers = {
    "X-Proxy-TTL" => "43200",
    "X-Proxy-Refresh": "true",
    "Helicone-Auth": "Bearer #{ENV.fetch('HELICONE_API_KEY')}"
  } # Optional
end