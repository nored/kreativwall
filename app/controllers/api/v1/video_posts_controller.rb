module Api::V1
  class VideoPostsController < ApplicationController
    before_action :set_video_post, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token
    before_action :authenticate , except: [:index, :show, :create]

    # GET /v1/video_posts
    def index
      render json: [], status: :unprocessable_entity
    end

    # GET /v1/video_posts/1
    def show
      render json: @video_post
    end

    # POST /v1/video_posts
    def create
      if get_user_by_token.nil?
        render_unauthorized
      else
        @video_post = VideoPost.new(video_post_params)
        @current_user = get_user_by_token
        @video_post.user_id = @current_user.id
        if @video_post.save
          render json: @video_post, status: :created
        else
          render json: @video_post.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT /v1/video_posts/1
    def update
      if @video_post.update(video_post_params)
        render json: @video_post
      else
        render json: @video_post.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/video_posts/1
    def destroy
      @video_post.destroy
    end

    protected
      # Authenticate with token based authentication
      def authenticate
        authenticate_token || render_unauthorized
      end

      def get_user_by_token
        authenticate_with_http_token do |token, options|
          @current_user = User.find_by(api_key: token)
        end
      end

      def authenticate_token
        @current_user = get_user_by_token
        video_post = set_video_post
        if video_post.user.api_key == @current_user.api_key
          return true
        end
        false
      end

      def render_unauthorized(realm = "Application")
        self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
        render json: 'Bad credentials', status: :unauthorized
      end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_video_post
        @video_post = VideoPost.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def video_post_params
        params.require(:video_post).permit(:contend, :user_id, :wall_id)
      end
  end
end
