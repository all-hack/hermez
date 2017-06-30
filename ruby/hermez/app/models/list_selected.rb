class ListSelected < ApplicationRecord

  def self.new_list
    if ListSelected.count == 0
      @list = ListSelected.new            
    else
      @list = ListSelected.first
    end
  end

  def get_cadet_list
    cadet_ids = self.cadet_list
    if cadet_ids
      cadet_list = cadet_ids.split("|")
    else
      return nil
    end
  end

  def add_cadet_id(cadet_id)    
    if cadet_list = self.get_cadet_list
      if cadet_id.to_s.in?(cadet_list)
        ;
      else
        self.cadet_list = self.cadet_list + "|"  + cadet_id.to_s
        self.save
      end
    else
      self.cadet_list = cadet_id
      self.save
    end    
  end

  def remove_cadet_id(cadet_id)    
    if cadet_list = self.get_cadet_list
      if cadet_id.to_s.in?(cadet_list)
        new_list = ""
        cadet_list.each do |id|
          if cadet_list.first == id and id != cadet_id.to_s
            new_list = id
          elsif id != cadet_id.to_s
            new_list = new_list + "|" + id
          end
        end
      else
        ;
      end          
    end    
    self.cadet_list = new_list
    self.save
  end

  def get_selected_cadets
    cadet_id_list = self.get_cadet_list
    cadet_list = []
    cadet_id_list.each do |id|      
      if id == ""
        ;
      else
        cadet_list.append(Cadet.find(id.to_i))
      end
    end
    return cadet_list
  end

  def get_selected_cadets_emails
    cadets_list = self.get_selected_cadets
    email_list = cadets_list.collect { |cadet| cadet.email}
  end



end
