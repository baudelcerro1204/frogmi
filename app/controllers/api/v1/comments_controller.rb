module Api
  module V1
    class CommentsController < ApplicationController
      def create
        feature = Feature.find_by(id: params[:feature_id])
        if feature.nil?
          render json: { error: 'Feature not found' }, status: :not_found
          return
        end
      
        body = params[:body].to_s.strip
        if body.empty?
          render json: { error: 'Comment body cannot be empty' }, status: :unprocessable_entity
          return
        end
      
        comment = feature.comments.create(body: body)
      
        render json: comment, status: :created
      end
    end
  end
end
