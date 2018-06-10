module Api::V1
  class LikesController < ApplicationController
    before_action :set_like, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token
    before_action :authenticate , except: [:show, :create]

    # GET /likes
    def index
      @likes = Like.all
      render json: @likes
    end

    # GET /likes/1
    def show
      render json: @like
    end

    # POST /likes
    def create
      if get_user_by_token.nil?
        render_unauthorized
      else
        @like = Like.new(like_params)
        @current_user = get_user_by_token
        @like.user_id = @current_user.id
        if @like.save
          render json: @like, status: :created, location: @like
        else
          render json: @like.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT /likes/1
    def update
      if @like.update(like_params)
        render json: @like
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end

    # DELETE /likes/1
    def destroy
      @like.destroy
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
        like = set_like
        if like.user.api_key == @current_user.api_key
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
      def set_like
        @like = Like.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def like_params
        params.require(:like).permit(:user_id, :video_post_id, :text_post_id, :picture_post_id)
      end
  end
end
