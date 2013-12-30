class ListingController < ApplicationController
  def index()
    if not params[:num_classes].nil?
      session[:num_classes] = params[:num_classes]
    end

    if not params[:start_time].nil?
      session[:start_time] = params[:start_time]
    end

    num_classes = session[:num_classes]
    if num_classes.nil?
      gon.num_classes = 3
    else
      gon.num_classes = num_classes
    end

    gon.start_time = session[:start_time]
  end
end
