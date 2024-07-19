# frozen_string_literal: true

class CreateDevelopmentIssues < ActiveRecord::Migration[7.1]
  def change
    create_table :development_issues do |t|
      t.string :key
      t.string :title, null: false
      t.string :assignee
      t.datetime :issue_updated_at
      t.text :description

      t.timestamps
    end
    add_index :development_issues, :key, unique: true
    add_index :development_issues, :assignee
  end
end
