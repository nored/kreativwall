module Api::V1
  class WallsController < ApiController
    before_action :set_wall, only: [:show, :edit, :update, :destroy]
    skip_before_action :verify_authenticity_token
    before_action :authenticate , except: [:index, :show, :create]

    # GET /v1/walls
    def index
      render json: [], status: :unprocessable_entity
    end

    # GET /v1/walls/1
    def show
      if @wall.nil?
        render json: [], status: :unprocessable_entity
      else
        session[:url] = @wall.slug
        pictures = @wall.picture_posts.all
        videos = @wall.video_posts.all
        texts = @wall.text_posts.all
        media = pictures + videos + texts
        media = media.sort_by(&:created_at).reverse
        mediaJson = {}
        i = 0
        media.each do |m|
          mediaJson[i] = {}
          if m.instance_of? TextPost
            mediaJson[i][:instance] = "t"
          end
          if m.instance_of? PicturePost
            mediaJson[i][:instance] = "p"
          end
          if m.instance_of? VideoPost
            mediaJson[i][:instance] = "v"
          end
          mediaJson[i][:likesize] = m.likes.size
          mediaJson[i][:commentssize] = m.comments.size
          mediaJson[i][:content] = m
          mediaJson[i][:comments] = m.comments
          i+=1
        end
        render json: mediaJson
      end
    end

    # POST /v1/walls
    def create
      if get_user_by_token.nil?
        render_unauthorized
      else
        @wall = Wall.new(wall_params)
        @current_user = get_user_by_token
        @wall.user_id = @current_user.id
        if @wall.save
          render json: @wall, status: :created
        else
          render json: @wall.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT /v1/walls/1
    def update
        if @wall.update(wall_params)
          render json: @wall
        else
          render json: @wall.errors, status: :unprocessable_entity
        end
    end

    # DELETE /v1/walls/1
    def destroy
        @wall.destroy
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
        wall = set_wall
        if wall.user.api_key == @current_user.api_key
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
      def set_wall
        @wall = Wall.find_by(slug: params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def wall_params
        params.require(:wall).permit(:name, :slug, :expireDate, :user_id)
      end
  end
end
