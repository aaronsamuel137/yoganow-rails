class ListingController < ApplicationController
  def index()
    num_classes = params[:num_classes]
    puts num_classes
    if num_classes.nil?
      gon.num_classes = 3
    else
      gon.num_classes = num_classes
    end
  end
end
