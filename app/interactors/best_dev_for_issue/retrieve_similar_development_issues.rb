# frozen_string_literal: true

module BestDevForIssue
  class RetrieveSimilarDevelopmentIssues < ApplicationInteractor
    # rubocop:disable all
    def call
      if context.key.blank? || context.title.blank? || context.key.blank? || context.embedding_provider.blank?
        store_missing_parameter_error
        return
      end

      config = {
        threshold: 0.20,
        limit: 5,
        distance_algorithm: 'cosine'
      }

      embedding_question = embedding_retriever
      result = similar_issues(embedding_question, config)
      context.similar_issues = result
    end
    # rubocop:enable all

    private

    def embedding_retriever
      if context.embedding_provider == 'openai'
        OpenaiEmbeddingRetriever.call(context.title)
      else
        OllamaEmbeddingRetriever.call(context.title)
      end
    end

    def similar_issues(embedding_question, config)
      threshold = config[:threshold]

      result = []
      result.concat(
        similar_issues_by_title(embedding_question, config).select { |e| e.neighbor_distance <= threshold }
      )
      result.concat(
        similar_issues_by_description(embedding_question, config).select { |e| e.neighbor_distance <= threshold }
      )
      result
    end

    def similar_issues_by_title(embedding, config)
      limit = config[:limit]
      distance_algorithm = config[:distance_algorithm]

      title_column = if context.embedding_provider == 'openai'
                       :embedding_title_text_embedding_ada_002
                     else
                       :embedding_title_mxbai_embed_large
                     end

      DevelopmentIssue.nearest_neighbors(title_column, embedding, distance: distance_algorithm).first(limit)
    end

    def similar_issues_by_description(embedding, config)
      limit = config[:limit]
      distance_algorithm = config[:distance_algorithm]

      description_column = if context.embedding_provider == 'openai'
                             :embedding_description_text_embedding_ada_002
                           else
                             :embedding_description_mxbai_embed_large
                           end
      DevelopmentIssue.nearest_neighbors(description_column, embedding, distance: distance_algorithm).first(limit)
    end
  end
end
