## README


This project have small and illustrative examples of using (for learning purpse) generate AI for different use cases;
Our objective is to share knowledge and engage to this team which is a disruptive change in software development market; 
In the following, we briefly describe the use cases and 

Finally we also include general AI links references at final;

Use cases:
* Using JIR, find developers that work on similar issues and provide this as a comment in a Issue card;
  * reads the JIRA issues export file and embedding it in an application table using pg_vector and the neighbor gem - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/best-dev-for-task/insert-data-to-best-dev-for-task.rb);
  * test the use case sending a new card information as parameter - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/best-dev-for-task/testing_interactors.rb);
  * using Jira-ruby gem creates a new comment in a JIRA issue - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/best-dev-for-task/testing_jira.rb);
* OpenAI sample requests reusing context. Also, it integrates with helicone platform - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/scripts/reusing_context_sample.rb);
* Using OpenAI to summarise problems found on a CSV having comments extracted from a Google Play application page - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/scripts/resume_google_play_reviews.rb);
* Testing OpenAI embeddings - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/scripts/test_openai_embeddings.rb);
* Running LLAMA models locally using OLLAMA  - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/learning/ollama_serve/testing_ollama_local_server.rb);
* Using OpenAI Agent API to upload files to a existing agent - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/wbs-assistant/create_and_upload_files_to_assistant.rb);
  * at the moment, ruby-openai did not support vector store apis, and, thus, we manually perform it;
  * reads a spreadsheet file from a google driver - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/wbs-assistant/read-from-drive.rb);
  * testing the message and thread agent endpoints from OpenAI - [link](https://github.com/daiflow/ai-learning-app/blob/master/projects/wbs-assistant/read-from-drive.rb);


Dependencies:

* Ruby - 3.3
* Rails - 7.1.3
* Postgres 15 (having pg_vector extension) via docker
* docker/docker-compose

Specific secret dependencies related to use cases:
* JIRA API token, username and jira organization url for finding the dev that already worked on similar issues;
* HELICONE_API_KEY at openai example of reusing context;
* OPENAI_ACCESS_TOKEN at several examples including find the dev with similar issues (JIRA) and OpenAi request agent samples;
* OLLAMA embedding and local host and models al example of local generative AI; (I tested but do not recommend using ollama embedding for portuguese sentences);
* GOOGLE_APPLICATION_CREDENTIALS and SPREADSHEET_ID to retrieve a spreadsheet file from a google driver. The first points to a absolute path having the json credential file;

References:
* https://www.youtube.com/watch?v=ahnGLM-RC1Y - great and mandatory OpenAI video for those want understande the different LLM techniques - A Survey of Techniques for Maximizing LLM Performance; 
* https://platform.openai.com/docs/guides/ - your best friend. official documentation;
* https://www.promptingguide.ai/ - this present pattern and guidelines to write better and consistet promtpts;
* https://poe.com/bot_rankings - it provides a benchmark of different generative models ranking them;
* https://ollama.com/ - platform that can be easily used to run opensource models in a private and local way;
* https://reinteractive.com/articles - ruby consulting company that have few ruby AI articles with illustrative sample codes;
* https://www.helicone.ai/ - platform for monitoring AI requests;
* https://github.com/patterns-ai-core/langchainrb - its a ruby version of langchain which is a very general tools with many features that makes easier to implement AI applications;
* https://github.com/alexrudall/ruby-openai - ruby gem to makes easy to perfom OpenAI API requests;
* https://github.com/ankane/neighbor - ruby gem to easily integrate embedding functions;
* https://flowiseai.com/ - low code platform that makes easy to provide AI agent chat applications and AI agent API endpoints and many other useful integrations;  
