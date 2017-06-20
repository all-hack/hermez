class CadetController < ApplicationController

  def new
    @cadet = Cadet.new
  end
   
  def create
    @cadet = Cadet.new
    
    @cadet.name = params[:name]
    @cadet.login = params[:login]

    if @cadet.save
      flash.now[:notice] = "Cadet, #{@cadet.login} successfully added to datastore"
      render controller: :cadet, action: :new
    else
      flash.now[:danger] = "Cadet, #{@cadet.login} not added to datastore"
      render controller: :cadet, action: :new
    end

  end


end
