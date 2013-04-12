class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    current_params, current_session = {}, {}
    #print "parameters"
    for par in params.keys do
	puts par
	if ["ratings", "sort_header"].count(par.to_s) != 0 then
	    current_params[par] = params[par]
	    if session[par] != params[par] then
		session[par] = params[par]
	    end
	end
    end
    #print "session parameters"
    for ses in session.keys do
	#puts ses
	if ["ratings", "sort_header"].count(ses.to_s) != 0 then
	   current_session[ses] = session[ses]
	end
    end
    if !session["ratings"] then
	@selected_ratings = @all_ratings
    else
	@rating_chosen = true
	@selected_ratings = session[:ratings].keys
    end
    #@selected_ratings = []
    #puts params.method_defined?("to_a")
    #puts session.method_defined?("to_a")
    #puts Movie.public_instance_methods
    #if params[:ratings] then
    #    @selected_ratings = params[:ratings].keys
    #    session[:ratings] = params[:ratings]
    #elsif params[:commit] then #after refresh without any checkboxes
#	@selected_ratings = @all_ratings
#	session[:ratings] = {}
#    else
#        @selected_ratings = @all_ratings
#	if !session[:ratings] or session[:ratings].length == 0 then
#	    session[:ratings] = {}
#	else
#	    @selected_ratings = session[:ratings].keys
#	end
 #   end
    #puts session[:selected_ratings]
    if current_params != current_session then
	redirect_required = true
    end
    #print current_params
    #print current_session
    if !session[:sort_header] then
	#@highlight_title = false
	#@highlight_release_date = false
        @movies = Movie.where(:rating => @selected_ratings)
    else
	#puts Movie.public_methods
	@highlight_title = session[:sort_header] == "title"
	@highlight_release_date = session[:sort_header] == "release_date"
	@movies = Movie.order(session[:sort_header]).where(:rating => @selected_ratings)
    end

    #nparams = params.to_hash.to_a + session[:sort_header] + session[:ratings]
    #print nparams
    #nparams = nparams.uniq
    
    if redirect_required then
	flash.keep
	#print "!!!!!!!!!!!!!!!!!!!!!!"
	redirect_to movies_path(current_session)
    end
    #end
    #@movies
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
