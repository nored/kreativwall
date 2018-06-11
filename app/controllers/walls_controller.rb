class WallsController < ApplicationController
  before_action :set_wall, only: [:show, :edit, :update, :destroy]

  # GET /walls
  # GET /walls.json
  def index
    # @walls = Wall.all
    redirect_to "/"
  end

  def url
    redirect_to "/#{params[:url]}"
  end

  def search
    if @wall.nil?
      redirect_to "/", notice: 'Wall was not found!'
    else
      redirect_to action: "show",:id => wall.id
    end
  end

  # GET /walls/1
  # GET /walls/1.json
  def show
    if @wall.nil?
      redirect_to "/", notice: 'Wall was not found!'
    else
      session[:url] = @wall.slug
      pictures = @wall.picture_posts.all
      videos = @wall.video_posts.all
      texts = @wall.text_posts.all
      @media = pictures + videos + texts
      @media = @media.sort_by(&:created_at)
      @i = 0
    end
  end

  # GET /walls/new
  def new
    redirect_to "/"
  end

  # GET /walls/1/edit
  def edit
    redirect_to "/#{@wall.slug}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wall
      session[:url] = params[:url]
      if params[:id].nil?
        @wall = Wall.find_by(slug: params[:url])
      else
        @wall = Wall.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wall_params
      params.require(:wall).permit(:name, :slug, :expireDate, :user_id)
    end
end
