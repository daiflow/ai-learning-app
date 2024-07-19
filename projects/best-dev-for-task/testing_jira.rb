require 'jira-ruby'

api_token = ENV['JIRA_API_TOKEN']

options = {
  username: 'alessandro.gurgel@smartfit.com', #teu_usuario
  password: api_token,
  site: 'https://devbio.atlassian.net/',
  context_path: '',
  auth_type: :basic
}


# client = JIRA::Client.new(options)
# issues = client.Issue.jql('project = PDSITE AND (status = "In Homolog" )');nil # JQL
# issues.each do |issue|
#   puts "-------------------------------------------------------"
#   puts "#{issue.key} -- #{issue.summary}"
#   puts "Status: #{issue.status.name}"
#   puts "Description: #{issue.description}"
#   comments = issue.comments
#   comments.each do |comment|
#     puts "Comment ID: #{comment.id}"
#     puts "Author: #{comment.author.displayName}"
#     puts "Body: #{comment.body}"
#     puts "Created at: #{comment.created}"
#     puts "Updated at: #{comment.updated}"
#     puts "-----------------------------------"
#   end
# end;nil


client = JIRA::Client.new(options)

issue_key = 'SMART-5574'
comment_body = 'This is a test comment.'

issue = client.Issue.find(issue_key)

# Add comment to the issue
comment = issue.comments.build
comment.save!(:body => "New comment from example script")

puts "Comment added successfully."