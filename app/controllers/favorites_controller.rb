class FavoritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    if current_user
      @movie.favorites.create(user: current_user)
      redirect_to @movie
    end
  end

  def destroy
    @favorite = @movie.favorites.find(params[:id])
    @favorite.destroy
    redirect_to @movie
  end

  private

  def set_movie
    @movie = Movie.find_by! slug: params[:movie_id]
  end
end
