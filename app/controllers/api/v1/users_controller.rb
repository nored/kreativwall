module Api::V1
  class UsersController < ApiController
    before_action :set_user, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token
    before_action :authenticate, except: [:index, :create, :show]
    # GET /v1/users
    def index
      render json: [], status: :unprocessable_entity
    end

    # GET /v1/users/1
    def show
      userJson = {}
      userJson[:id] = @user.id
      userJson[:name] = @user.name
      userJson[:surname] = @user.surname
      userJson[:picture] = {}
      userJson[:picture][:url] = "#{request.base_url}#{@user.picture.url}"
      userJson[:picture][:thumb] = {}
      userJson[:picture][:thumb][:url] = "#{request.base_url}#{@user.picture.thumb.url}"
      userJson[:created_at] = @user.created_at
      userJson[:api_key] = @user.name == "Anonymous" ? @user.api_key : "**********"
      render json: userJson
    end

    # POST /v1/users
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/users/1
    def destroy
      @user.destroy
    end

    protected
      # Authenticate with token based authentication
      def authenticate
        authenticate_token || render_unauthorized
      end

      def authenticate_token
        authenticate_with_http_token do |token, options|
          @current_user = User.find_by(api_key: token)
        end
        user = set_user
        if user.api_key == @current_user.api_key
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
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:name, :surname, :picture)
      end
  end
end
