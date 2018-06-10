module Api::V1
  class CommentsController < ApiController
    before_action :set_comment, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token
    before_action :authenticate , except: [:show, :create]

    # GET /v1/comments
    def index
      @comments = Comment.all
      render json: @comments
    end

    # GET /v1/comments/1
    def show
      render json: @comment
    end

    # POST /v1/comments
    def create
      if get_user_by_token.nil?
        render_unauthorized
      else
        @comment = Comment.new(comment_params)
        @current_user = get_user_by_token
        @current_user.user_id = @current_user.id
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT /v1/comments/1
    def update
      if @comment.update(comment_params)
        render json: @comment
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/comments/1
    def destroy
      @comment.destroy
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
        comment = set_comment
        if comment.user.api_key == @current_user.api_key
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
      def set_comment
        @comment = Comment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def comment_params
        params.require(:comment).permit(:body, :user_id, :video_post_id, :text_post_id, :picture_post_id)
      end
  end
end
