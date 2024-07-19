# frozen_string_literal: true

# https://developers.google.com/android-publisher/reply-to-reviews?hl=pt_BR
# https://developers.google.com/android-publisher/api-ref/rest/v3/reviews?hl=pt-br

require 'csv'

rows = CSV.read('prompts/data/smarfitapp_202311.csv', headers: true, encoding: 'utf-16le')

columns = {
  app_version: 2,
  rating: 9,
  review: 11
}

csv_array_rows = rows.to_a.select do |e|
  e[columns[:app_version]].to_i.positive? && e[columns[:rating]] && e[columns[:review]]
end.map do |e|
  {
    app_version: e[columns[:app_version]],
    rating: e[columns[:rating]],
    review: e[columns[:review]]
  }
end

possible_error_rows = csv_array_rows.select { |e| e[:rating].to_i <= 3 }

client = OpenAI::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
end

messages = [
  { role: 'system',
    content: 'You are responsible for evaluating reviews in a Google Play mobile application on fitness segment. It saves and tracks trainings in a gym.' }
]
possible_error_rows.each_with_index do |review_data, index|
  messages << {
    role: 'system', content: "review #{index}: version: #{review_data[:app_version]}, rating: #{review_data[:rating]}, review: #{review_data[:review]}"
  }
end

messages << {
  role: 'user', content: 'Considering the reviews, group all related errors and summarize me which bugs or errors occurred according the reviews in respective app versions.'
}

response = client.chat(
  parameters: {
    model: 'gpt-3.5-turbo', # Required.
    messages:,
    temperature: 0.7
  }
)
puts response.dig('choices', 0, 'message', 'content')

# Based on the reviews, here is a summary of the bugs or errors reported in the app versions mentioned:
#
#                                                                                              For version 4.0.9:
#   1. The app is not saving the weight used in workouts - mentioned in reviews 0, 5, and 22.
#   2. The app is not finalizing workouts and not saving weights after the latest update - mentioned in reviews 19.
#   3. Multiple issues after the latest update - mentioned in reviews 3, 11, and 33.
#   4. Users are getting logged out in the middle of their workout due to updates - mentioned in reviews 26.
#   5. The app is lagging and freezing a lot - mentioned in review 28.
#   6. The app is not allowing users to customize their workouts - mentioned in review 30.
#   7. Some users are experiencing issues with saving their height - mentioned in review 31.
#   8. Some users are having trouble editing their personal information - mentioned in review 21.
#   9. The app does not save weight information - mentioned in review 22.
#   10. Financial transactions are not working properly - mentioned in review 23.
#
#   For version 4.1.0:
#   1. Users are facing issues with making payments through PIX and boleto - mentioned in reviews 43 and 47.
#   2. Users are having trouble accessing profiles and being shown as offline - mentioned in reviews 40 and 50.
#
#   For version 4.1.2:
#   1. Users are unable to access profiles and other services, only the training section is available - mentioned in reviews 57 and 71.
#   2. The app is not syncing routines from the previous version and lacks customization options - mentioned in review 68.
#   3. Users are facing connectivity issues and being shown as offline - mentioned in reviews 70.
#
#   It is evident that the app has been facing various issues related to saving workout data, payment processing, user profiles, and overall functionality across different versions based on the reviews provided.
