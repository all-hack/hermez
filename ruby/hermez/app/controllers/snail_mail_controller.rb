class SnailMailController < ApplicationController
  

  def index
    @cadets = Cadet.all
  end

end
