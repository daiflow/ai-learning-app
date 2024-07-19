# frozen_string_literal: true

class RenameEmbeddingColumnsToDevelopmentIssues < ActiveRecord::Migration[7.1]
  def change
    rename_column :development_issues, :embedding_description, :embedding_description_mxbai_embed_large
    rename_column :development_issues, :embedding_title, :embedding_title_mxbai_embed_large
  end
end
