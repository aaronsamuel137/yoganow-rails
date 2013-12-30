class ListingController < ApplicationController
  def index()
    if not params[:num_classes].nil?
      session[:num_classes] = params[:num_classes]
    end

    if not params[:start_time].nil?
      session[:start_time] = params[:start_time]
    end

    if session[:num_classes].nil?
      gon.num_classes = '3'
      @num_classes = '3'
      session[:num_classes] = '3'
    elsif session[:num_classes] == '-1'
      session[:num_classes] = '-1'
      @num_classes = 'all remaining'
    else
      gon.num_classes = session[:num_classes]
      @num_classes = session[:num_classes]
    end

    gon.start_time = session[:start_time]
    if session[:start_time] == '-1'
      @start_time = 'now'
    else
      time = DateTime.strptime(session[:start_time].to_s, "%H").strftime("%I:%M %p")
      @start_time = 'at ' + time
    end
  end
end
