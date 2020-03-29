module MoviesHelper

  def total_gross_value(movie)
    if movie.flop?
       "Flop!"
    else
      number_to_currency(movie.total_gross, unit: "€", precision: 0)
    end
  end

  def year_of(movie)
    movie&.released_on&.strftime("%Y") 
  end

  def average_stars(movie)
    if movie.average_stars.blank?
      content_tag(:b, "No reviews")
    else
      number_with_precision(movie.average_stars, precision: 0) + " *"
    end
  end

  def fave_or_unfave_button(movie, favorite)
    if favorite
      button_to '♥️ UnFave', movie_favorite_path(movie, favorite), method: :delete
    else
      button_to '♥️ Fave', movie_favorites_path(@movie)
    end
  end
end 

