class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
    sort = params[:sort_list]
    doMySort(sort)
    
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings]
    @movies = Movie.where("rating in (?)", @selected_ratings.keys)
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy # built in function, a ruby function
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def sort_movies_by_name
    @movie = Movie.all
    #@movie = @movie.sort_by { |k| k[:title] }
    @movie = Movie.all.sort_by { |k| k[:title] }
    #@movie.update_attributes!(movie_params)  # take this out?
    #redirect_to movies_path
  end
  
  def sort_movies_by_release_date
    @movie = Movie.all
    @movie = @movie.sort_by { |date| date[:release_date][-4,4] } 
    #@movie.update_attributes!(movie_params) # take this out?
    redirect_to movies_path
  end

private

  def doMySort(sort)
    if sort == 'title' || sort == 'release_date'
      @movies = @movies.order(sort)
    end
    
    if sort == 'title'
      @title_header = 'hilite'
    elsif sort == 'release_date'
      @release_date_header = 'hilite'
    end
    
  end

end
