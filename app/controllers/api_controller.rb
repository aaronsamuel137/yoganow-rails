require 'studio_data'
require 'studio_constants'

class ApiController < ApplicationController
  def index()
    studio_name = params[:studio]
    num_classes = params[:num_classes].to_i
    start_time = params[:start_time].to_i

    case studio_name
    when 'yogapod'
      studio = StudioConstants::YOGAPOD_DATA
    when 'corepower_south'
      studio = StudioConstants::CP_SOUTH_DATA
    when 'corepower_north'
      studio = StudioConstants::CP_NORTH_DATA
    when 'corepower_hill'
      studio = StudioConstants::CP_HILL_DATA
    when 'yogaworkshop'
      studio = StudioConstants::YOGA_WORKSHOP_DATA
    else
      puts studio_name
    end

    data = ApiHelper.get_studio_data(studio, num_classes, start_time)
    render json: data
  end
end
