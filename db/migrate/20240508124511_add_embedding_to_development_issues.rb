# frozen_string_literal: true

# rubocop:disable all
class AddEmbeddingToDevelopmentIssues < ActiveRecord::Migration[7.1]
  def change
    add_column :development_issues, :embedding_description, :vector, null: false
    add_column :development_issues, :embedding_title, :vector, null: false
  end
end
# rubocop:enable all
