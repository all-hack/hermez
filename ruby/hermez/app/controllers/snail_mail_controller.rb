class SnailMailController < ApplicationController
  

  def index
    @cadets = Cadet.all    
    list = ListSelected.first
    @selected_cadets = []
    if list
      @selected_cadets = list.get_selected_cadets
    end
  end


  def select_cadet

    @list = ListSelected.new_list        
    cadet = Cadet.find {|s| s.login == params['cadet_login'] }
    @list.add_cadet_id(cadet.id)

    redirect_to root_path
  end
    
  def deselect_cadet

    @list = ListSelected.first
    cadet = Cadet.find {|s| s.login == params['cadet_login'] }
    @list.remove_cadet_id(cadet.id)

    redirect_to root_path
  end

  def clear_list
    
    if list = ListSelected.first
      list.destroy
    end

    redirect_to root_path
  end

  def send_email
    if list = ListSelected.first
      if list.cadet_list != ""        
        ApplicationMailer.mail_received(list).deliver
        list.destroy
      end
    end

    redirect_to root_path
  end


end
