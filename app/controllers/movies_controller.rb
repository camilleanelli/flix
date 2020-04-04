class MoviesController < ApplicationController
  before_action :require_signin, except: [:show, :index]
  before_action :require_admin, except: [:show, :index]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  
  def index
    @movies = Movie.includes(:reviews).send(movies_scope)
  end

  def show 
    @fans = @movie.fans
    @genres = @movie.genres
    @favorite = current_user.favorites.find_by(movie_id: @movie.id) if current_user
  end

  def edit
  end

  def update
    if @movie.update(params_movies)
      redirect_to movies_path, notice: "Movie successfully updated!"
    else 
      render :edit
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(params_movies)
    if @movie.save 
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new
    end
  end

  def destroy
    if @movie.destroy 
      redirect_to movies_path, alert: "I'm sorry, Dave, I'm afraid I can't do that!"
    else
      render :show
    end
  end

  private

  def set_movie
    @movie = Movie.find_by! slug: params[:id]
  end

  def movies_scope
    if params[:filter].in? %w(upcoming recent hits flops)
      params[:filter]
    else
      :released
    end
  end

  def params_movies
    params.require(:movie).permit(:rating, :title, :total_gross, :released_on, :description, :duration, :director, :main_image, genre_ids: [])
  end
end
