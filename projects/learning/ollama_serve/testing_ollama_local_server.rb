# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

# https://github.com/ollama/ollama/blob/main/docs/api.md

uri = URI('http://localhost:11434/api/chat')
request = Net::HTTP::Post.new(uri)
request.content_type = 'application/json'
request.body = JSON.dump({
                           model: 'ruby',
                           messages: [
                             {
                               role: 'user',
                               content: 'How can I covert a PDF into text in Ruby?'
                             }
                           ],
                           stream: false
                         })

response = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.read_timeout = 120
  http.request(request)
end

puts response.body
