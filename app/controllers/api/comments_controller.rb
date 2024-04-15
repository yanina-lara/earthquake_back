module Api
  class CommentsController < ApplicationController
    def create
      feature = Feature.find_by(external_id: params[:feature_id])
      comment = feature.comments.build(comment_params)

      if comment.save
        render json: comment, serializer: CommentSerializer, status: :created
      else
        render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.permit(:body, :feature_id)
    end
    
  end
end
