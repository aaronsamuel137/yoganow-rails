require 'studio_data'
require 'studio_constants'

class ApiController < ApplicationController
  def index()
    num_classes = params[:num_classes].to_i
    start_time = params[:start_time].to_i

    data = []
    StudioConstants::STUDIOS.each do |studio|
      data.push(ApiHelper.get_studio_data(studio, num_classes, start_time))
    end

    render json: data
  end
end
