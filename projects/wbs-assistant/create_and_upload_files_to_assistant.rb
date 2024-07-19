client = OpenAI::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
end

response = client.assistants.create(
  parameters: {
    model: "gpt-4o",
    name: "OpenAI-Ruby test assistant",
    description: nil,
    instructions: "You are a Ruby dev bot. When asked a question, write and run Ruby code to answer the question",
    tools: [
      { type: "file_search" },
    ],
    "metadata": { my_internal_version_id: "1.0.0" }
  })
# assistant_id = response["id"]

assistant_id = 'asst_Vxe6UroRdXDrSoOBDXLR2qNy'

# subir o arquivo no files
response = client.files.upload(parameters: { file: "organograma_data.txt", purpose: "assistants" })

#file_id = response["id"]

file_id = "file-DmCl90A7LNDITyrSh7BIg8Oy"

# subir o arquivo no vector store
uri = URI("https://api.openai.com/v1/vector_stores")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
request['Authorization'] = "Bearer #{ENV['OPENAI_ACCESS_TOKEN']}"
request['OpenAI-Beta'] = "assistants=v2"
request.body = {
  name: "organograma vector store",
  file_ids: [file_id]
}.to_json
response = http.request(request)
response = JSON.parse(response.body)

# vector_store_id = response["id"]

vector_store_id = "vs_eZ7TUwiFeo1AVbeWigqCk5cN"

# atualizar assistant com o file_ids
response = client.assistants.modify(
  id: assistant_id,
  parameters: {
    tool_resources: {
      "file_search": {
        "vector_store_ids": [vector_store_id]
      }
    },
  })