class Cadet < ApplicationRecord
  validates :login, presence: true, uniqueness: true


  def self.import_cadets(cadet_json_list)
    # Create the client with your credentials
    client = OAuth2::Client.new(ENV['UID_42'], ENV['SECRET_42'], site: "https://api.intra.42.fr")
    # Get an access token
    token = client.client_credentials.get_token

    success = 0
    fail = 0
    total = 0

    cadet_json_list.each do |hash|      
      begin
          cadet_json = token.get("/v2/users/#{hash['id']}").parsed
    
          cadet = Cadet.new
                              
          cadet.name = cadet_json["first_name"] + " " + cadet_json["last_name"]
          cadet.login = cadet_json['login']          
          cadet.email = cadet_json['email']

          if cadet.save      
            success += 1
            total += 1
          else
            fail += 1
            total   += 1   
          end          
                      
      rescue StandardError => e        
          puts "error in Cadet.import_cadets"          
          puts e
          fail += 1
          total += 1   
      end
    end

    return {success: success.to_s, fail: fail.to_s, total: total.to_s}

  end




end
