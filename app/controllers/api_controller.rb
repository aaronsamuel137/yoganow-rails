require 'studio_data'
require 'studio_constants'

class ApiController < ApplicationController
  def index()
    data = []
    StudioConstants::STUDIOS.each do |studio|
      data.push(ApiHelper.get_studio_data(studio))
    end

    render json: data
  end
end
