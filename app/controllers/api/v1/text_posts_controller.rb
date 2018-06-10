module Api::V1
  class TextPostsController < ApiController
    before_action :set_text_post, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token
    before_action :authenticate , except: [:show, :create]

    # GET /v1/text_posts
    def index
      @text_posts = TextPost.all
      render json: @text_posts
    end

    # GET /v1/text_posts/1
    def show
      render json: @text_post
    end

    # POST /v1/text_posts
    def create
      if get_user_by_token.nil?
        render_unauthorized
      else
        @text_post = TextPost.new(text_post_params)
        @current_user = get_user_by_token
        @text_post.user_id = @current_user.id
        if @text_post.save
          render json: @text_post, status: :created
        else
          render json: @text_post.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT /v1/text_posts/1
    def update
      if @text_post.update(text_post_params)
        render json: @text_post
      else
        render json: @text_post.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/text_posts/1
    def destroy
      @text_post.destroy
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
        text_post = set_text_post
        if text_post.user.api_key == @current_user.api_key
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
      def set_text_post
        @text_post = TextPost.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def text_post_params
        params.require(:text_post).permit(:contend, :user_id, :wall_id)
      end
  end
end
