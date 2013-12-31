class ApiController < ApplicationController
  def index()
    studio_name = params[:studio]
    num_classes = params[:num_classes].to_i
    start_time = params[:start_time]

    data = ApiHelper.get_studio_data(studio_name, num_classes, start_time)
    render json: data
  end
end
