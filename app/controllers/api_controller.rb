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

  def sutra()
    prev_verse = params[:previous]
    if prev_verse == 'nil'
      prev_verse = 0
    end
    quote = Sutra.all(order: :verse)[prev_verse.to_i]
    text = "<br>
            <p>#{quote.devanagari}<br><br>
               #{quote.transliteration}<br><br>
               #{quote.english}<br><br>
            </p>
            <small class=\"pull-right\"><a target=\"_blank\" href=\"#{quote.link}\">Yoga Sutras #{quote.verse}</a></small>"
    render text: text
  end
end
