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
      redirect_to action: "new"
    else
      redirect_to action: "show",:id => wall.id
    end
  end

  # GET /walls/1
  # GET /walls/1.json
  def show
    if @wall.nil?
      redirect_to action: "new"
    else
      session[:url] = @wall.slug
      @foo = request.original_url
      @qrcode = RQRCode::QRCode.new( @wall.slug, :size => 10, :level => :h )
      pictures = @wall.picture_posts.all
      videos = @wall.video_posts.all
      texts = @wall.text_posts.all
      @media = pictures + videos + texts
      @users = Array.new
      if @media.present? 
        @media = @media.sort_by(&:created_at).reverse!
        pictures.each do |p|
          @users << p.user_id
        end
        videos.each do |v|
          @users << v.user_id
        end
        texts.each do |t|
          @users << t.user_id
        end
        @users.uniq!.reverse! if @users.size > 1
      end
    end
  end

  # GET /walls/new
  def new
    @cancel_wall = "/"
    @wall = Wall.new(:slug => session[:url])
  end

  # GET /walls/1/edit
  def edit
    redirect_to "/#{@wall.slug}"
  end

   # POST /walls
   def create
    @wall = Wall.new(wall_params)
    respond_to do |format|
      if @wall.save
        format.html { redirect_to "/#{params[:wall][:slug]}", notice: 'Wall was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /walls/1
  def update
    respond_to do |format|
      if @wall.update(wall_params)
        format.html { redirect_to "/#{@wall.slug}", notice: 'Wall was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /walls/1
  def destroy
    @wall.destroy
    respond_to do |format|
      format.html { redirect_to "/", notice: 'Wall was successfully destroyed.' }
    end
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
