class ListingController < ApplicationController
  def index()
    gon.locations = StudioLocations.all
    @quote = Sutra.first(:order => "RANDOM()")
  end
end
