module Api::V1
  class PicturePostsController < ApiController
    before_action :set_picture_post, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token
    before_action :authenticate , except: [:index, :show, :create]

    # GET /v1/picture_posts
    def index
      render json: [], status: :unprocessable_entity
    end

    # GET /v1/picture_posts/1
    def show
      pictureJson = {}
      pictureJson[:id] = @picture_post.id
      pictureJson[:content] = {}
      pictureJson[:content][:url] = "#{request.base_url}#{@picture_post.contend.url}"
      pictureJson[:content][:thumb] = {}
      pictureJson[:content][:thumb][:url] = "#{request.base_url}#{@picture_post.contend.thumb.url}"
      pictureJson[:user_id] = @picture_post.user_id
      pictureJson[:wall_id] = @picture_post.wall_id
      pictureJson[:created_at] = @picture_post.created_at
      pictureJson[:updated_at] = @picture_post.updated_at
      # render json: @picture_post
      render json: pictureJson
    end

    # POST /v1/picture_posts
    def create
      if get_user_by_token.nil?
        render_unauthorized
      else
        @picture_post = PicturePost.new(picture_post_params)
        @current_user = get_user_by_token
        @picture_post.user_id = @current_user.id
        if @picture_post.save
          render json: @picture_post, status: :created
        else
          render json: @picture_post.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT /v1/picture_posts/1
    def update
      if @picture_post.update(picture_post_params)
        render json: @picture_post
      else
        render json: @picture_post.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/picture_posts/1
    def destroy
      @picture_post.destroy
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
        picture_post = set_wall
        if picture_post.user.api_key == @current_user.api_key
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
      def set_picture_post
        @picture_post = PicturePost.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def picture_post_params
        params.require(:picture_post).permit(:contend, :user_id, :wall_id)
      end
  end
end
