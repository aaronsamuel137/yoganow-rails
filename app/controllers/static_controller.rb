class StaticController < ApplicationController
  def contact
    gon.hello = 1
  end
end
