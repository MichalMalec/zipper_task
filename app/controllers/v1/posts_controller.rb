class V1::PostsController < ApplicationController
    before_action :authenticate_user!
    
    def create
      post = Post.new(post_params)
      if post.save
        render json: { id: post.id, title: post.title, file_url: url_for(post.file) }, status: :created
      else
        render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.require(:post).permit(:title, :file)
    end
end
