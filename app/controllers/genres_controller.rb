class GenresController < ApplicationController
  before_action :require_signin
  before_action :require_admin
  before_action :set_genre
  
  def index 
    @genres = Genre.all
  end

  def show 
    @movies = @genre.movies
  end

  def new
    @genre = Genre.new
  end

  def create 
    @genre = Genre.new(params_genre)
    if @genre.save
      redirect_to genres_path
    else
      render :new
    end
  end

  def edit
  end

  def update 
    if @genre.update(params_genre)
      redirect_to @genre
    else
      render :edit
    end
  end

  def destroy
    if @genre.destroy 
      redirect_to genres_path
    end
  end

  private 

  def set_genre
    @genre = Genre.find_by! slug: params[:id]
  end

  def params_genre
    params.require(:genre).permit!
  end
end
