# frozen_string_literal: true

FactoryBot.define do
  factory :development_issue do
    sequence(:key) { |i| "GURGEL_00#{i}" }
    title { 'Faca a nova funcionalidade' }
    sequence(:assignee) { |_| Faker::Name.name }
    issue_updated_at { DateTime.now }
    sequence(:description) { |i| "description of issue GURGEL_00#{i}" }
    embedding_title_mxbai_embed_large { [0.12330355, -0.54623425] }
    embedding_description_mxbai_embed_large { [0.12330355, -0.54623425] }
    embedding_title_text_embedding_ada_002 { [0.22330355, -0.84623425] }
    embedding_description_text_embedding_ada_002 { [0.22330355, -0.84623425] }
  end
end