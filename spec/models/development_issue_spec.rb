# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevelopmentIssue do
  let(:development_issue_attrs) do
    attributes_for(:development_issue)
  end

  it 'creates a valid company' do
    expect do
      described_class.create(development_issue_attrs)
    end.to change(described_class, :count).by(1)
  end
end
