result = BestDevForIssue::RetrieveSimilarDevelopmentIssues.
  call(
    {
      title: 'Otimizar processo de faturamento dos franqueados',
      key: 'SMART-6405',
      description:
        'Recentemente esse processo impactou o banco de escrita causando instabilidade no Sistema, visto que a consulta executada pode ser bem custosa.',
      embedding_provider: 'openai'
    })

result.similar_issues.map {|e| [e.title, e.key, e.assignee, e.neighbor_distance]}

# similar_issues = result.similar_issues;nil
result = BestDevForIssue::PromptExecutor.call(result)
result = BestDevForIssue::CommentPromptResponseOnJira.call(result)

################3
#
result = BestDevForIssue::RecommendDeveloper.
  call(
    {
      title: 'Otimizar processo de faturamento dos franqueados',
      key: 'SMART-6405',
      description:
        'Recentemente esse processo impactou o banco de escrita causando instabilidade no Sistema, visto que a consulta executada pode ser bem custosa.',
      embedding_provider: 'openai',
      prompt_provider: 'openai'
    }
  );nil