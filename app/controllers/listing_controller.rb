class ListingController < ApplicationController
  def index()
    # check if num_classes query was given
    if not params[:num_classes].nil?
      session[:num_classes] = params[:num_classes].to_i
    end

    # if no value for num_classes in session, use default of 3
    if session[:num_classes].nil?
      session[:num_classes] = 3
      @num_classes = 3
    elsif session[:num_classes] == -1
      @num_classes = 'all remaining classes'
    elsif session[:num_classes] == 1
      @num_classes = "1 class"
    else
      @num_classes = "#{session[:num_classes]} classes"
    end
    gon.num_classes = session[:num_classes]

    # check if start_time query was given
    if not params[:start_time].nil?
      session[:start_time] = params[:start_time].to_i
    end

    # if no value for start_time in session, use default of now
    if session[:start_time].nil?
      session[:start_time] = -1
      @start_time = 'now'
    elsif session[:start_time] == -1
      @start_time = 'now'
    else
      time = DateTime.strptime(session[:start_time].to_s, "%H").strftime("%I:%M %p")
      @start_time = 'at ' + time
    end
    gon.start_time = session[:start_time]

    gon.studios = ApiHelper::STUDIO_NICKNAMES
  end
end
