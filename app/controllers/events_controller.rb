class EventsController < ApplicationController
  def events
    gon.hello = 1
  end
end
