# frozen_string_literal: true
# rubocop:disable all
class AddAda002EmbeddingsToDevelopmentIssues < ActiveRecord::Migration[7.1]
  def change
    add_column :development_issues, :embedding_description_text_embedding_ada_002, :vector
    add_column :development_issues, :embedding_title_text_embedding_ada_002, :vector
  end
end
# rubocop:enable all
