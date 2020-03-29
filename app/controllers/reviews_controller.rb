class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index 
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(params_review)
    @review.user = current_user
    if @review.save
      redirect_to movie_reviews_path(@movie), notice: "Thanks for your review !"
    else 
      render :new
    end
  end

  def edit 
    set_review
  end

  def update 
    set_review
    if @review.update params_review
      redirect_to movie_reviews_path(@movie)
    else
      render :edit
    end
  end

  def destroy 
    set_review
    if @review.destroy 
      redirect_to movie_reviews_path(@movie)
    end
  end

  private

  def set_movie 
    @movie = Movie.find_by! slug: params[:movie_id]
  end

  def set_review
    @review = @movie.reviews.find(params[:id])
  end

  def params_review
    params.require(:review).permit(:comment, :stars)
  end
  
end
