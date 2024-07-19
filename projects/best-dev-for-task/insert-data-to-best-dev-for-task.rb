# frozen_string_literal: true

require 'csv'

require 'net/http'
require 'uri'
require 'json'

def ollama_embedding_from_text(description)
  uri = URI('http://localhost:11434/api/embeddings')
  request = Net::HTTP::Post.new(uri)
  request.content_type = 'application/json'
  # este modelo de embeddings corretamente ignora diferecas de acentos e uppercase/lowcase
  request.body = JSON.dump({
                             model: 'mxbai-embed-large',
                             prompt: description,
                             stream: false
                           })

  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.read_timeout = 10
    http.request(request)
  end
  JSON.parse(response.body)['embedding']
end

def open_ai_embedding_from_text(description, openai_client)
  response = openai_client.embeddings(
    parameters: {
      model: "text-embedding-ada-002",
      input: description
    }
  )
  response.dig("data", 0, "embedding")
end

openai_client = OpenAI::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
end

headers = {
  title: 'Resumo',
  jira_key: 'Chave da ocorrência',
  assignee: 'Responsável',
  updated_at: 'Atualizado',
  description: 'Descrição'
}

issues = CSV.open('projects/best-dev-for-task/data/smart_sytem_issues_after_20230101.csv', col_sep: ',',
                                                                                           headers: true).map do |row|
  {
    key: row[headers[:jira_key]],
    title: row[headers[:title]],
    assignee: row[headers[:assignee]],
    issue_updated_at: row[headers[:updated_at]],
    description: row[headers[:description]]
  }
end

filtered_issues = issues.select { |issue| issue[:description].length > 100 }
filtered_issues.each_with_index do |issue_raw, index|
  next if DevelopmentIssue.exists?(key: issue_raw[:key])

  regexp = /(Objetivo|Contexto|objetivo|contexto|\*|\n)/
  tuned_description = issue_raw[:description].gsub(regexp, '')
  DevelopmentIssue.create!(
    key: issue_raw[:key],
    title: issue_raw[:title],
    description: issue_raw[:description],
    issue_updated_at: issue_raw[:issue_updated_at],
    assignee: issue_raw[:assignee],
    embedding_description_mxbai_embed_large: ollama_embedding_from_text(tuned_description),
    embedding_title_mxbai_embed_large: ollama_embedding_from_text(issue_raw[:title]),
    embedding_description_text_embedding_ada_002: open_ai_embedding_from_text(tuned_description, openai_client),
    embedding_title_text_embedding_ada_002: open_ai_embedding_from_text(issue_raw[:title], openai_client)
  )
  puts index if (index % 10).zero?
end






question = 'Otimizar processo de faturamento dos franqueados'
question_embedding = ollama_embedding_from_text(question)
# qunanto menor a distancia melhor.
#  related_issues = DevelopmentIssue.nearest_neighbors(:embedding_title, question_embedding, distance: "cosine").first(3).map &:neighbor_distance
DevelopmentIssue.nearest_neighbors(:embedding_title_mxbai_embed_large, question_embedding, distance: 'cosine').first(3)

# https://aws-assets.kiwify.com.br/fBQzJgXmwNJFxoL/Gen-AI-Basics---Aula-8_01636298f13a4480925db12ed24c9c29_bedbbe00e65a4135a9878f35a8503046.pdf



question = 'Otimizar processo de faturamento dos franqueados'
question_embedding = open_ai_embedding_from_text(question, openai_client)
result = DevelopmentIssue.nearest_neighbors(:embedding_title_text_embedding_ada_002, question_embedding, distance: 'cosine').first(5);nil
p result.map {|e| [e.title, e.key, e.assignee, e.neighbor_distance]}