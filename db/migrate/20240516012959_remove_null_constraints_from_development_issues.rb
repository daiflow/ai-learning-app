# frozen_string_literal: true

class RemoveNullConstraintsFromDevelopmentIssues < ActiveRecord::Migration[7.1]
  def change
    change_column_null :development_issues, :embedding_description_mxbai_embed_large, true
    change_column_null :development_issues, :embedding_title_mxbai_embed_large, true
  end
end
