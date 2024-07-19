# frozen_string_literal: true

require 'csv'

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
  development_issue = DevelopmentIssue.find_by(key: issue_raw[:key])
  next unless development_issue.present?
  next if development_issue.embedding_title_text_embedding_ada_002.present? && development_issue.embedding_description_text_embedding_ada_002.present?

  development_issue.update!(
    embedding_description_text_embedding_ada_002: open_ai_embedding_from_text(development_issue.description, openai_client),
    embedding_title_text_embedding_ada_002: open_ai_embedding_from_text(development_issue.title, openai_client)
  )
  puts index if (index % 50).zero?
end;nil

