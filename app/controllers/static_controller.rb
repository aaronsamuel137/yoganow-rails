class StaticController < ApplicationController
  def contact
    gon.hello = 1
  end

  def test
    gon.hello = 1
  end
end
