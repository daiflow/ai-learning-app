client = OpenAI::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
end

assistant_id = 'asst_yJEqyqRzYDBI7sSepRgNtMR0'

assistant = client.assistants.retrieve(id: assistant_id)

p assistant['name']

# Create thread
response = client.threads.create # Note: Once you create a thread, there is no way to list it
# or recover it currently (as of 2023-12-10). So hold onto the `id`
thread_id = response["id"]

# Add initial message from user (see https://platform.openai.com/docs/api-reference/messages/createMessage)
message_id = client.messages.create(
  thread_id: thread_id,
  parameters: {
    role: "user", # Required for manually created messages
    content: "Can you help me write an API library to interact with the OpenAI API please?"
  })["id"]

# Retrieve individual message
message = client.messages.retrieve(thread_id: thread_id, id: message_id)

# Review all messages on the thread
messages = client.messages.list(thread_id: thread_id)



#######
# Create a new message in existing thread
# ########

thread_id = 'thread_4n7EvwGFtwLzq6jZOHqZdCTA'
message_id = client.messages.create(
  thread_id: thread_id,
  parameters: {
    role: "user", # Required for manually created messages
    content: "Quem sao os desenvolvedores responsaveis pelo Smart Fit App Server?"
  })["id"]

message = client.messages.retrieve(thread_id: thread_id, id: message_id)

response = client.runs.create(thread_id: thread_id,
                              parameters: {
                                assistant_id: assistant_id
                              })
run_id = response['id']

response = client.runs.retrieve(id: run_id, thread_id: thread_id)
status = response['status']

messages = client.messages.list(thread_id: thread_id, parameters: { order: 'desc' }).dig('data', 0, 'content', 0, 'text', 'value' )