# frozen_string_literal: true

class DevelopmentIssue < ApplicationRecord
  validates :key, :title, :description, presence: true
  validates :key, uniqueness: true

  has_neighbors :embedding_description_mxbai_embed_large
  has_neighbors :embedding_title_mxbai_embed_large

  has_neighbors :embedding_description_text_embedding_ada_002
  has_neighbors :embedding_title_text_embedding_ada_002
end
