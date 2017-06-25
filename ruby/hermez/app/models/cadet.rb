class Cadet < ApplicationRecord
  validates :login, presence: true, uniqueness: true

  def self.collect_cadet_info!(cadet, cadet_json)
    cadet.name = cadet_json["first_name"].downcase + " " + cadet_json["last_name"].downcase
    cadet.login = cadet_json['login']          
    cadet.email = cadet_json['email']
    cadet.image_url = cadet_json['image_url']
    cadet.mails_received = 0
    ActiveRecord::Base.connection_pool.with_connection do
      cadet.save 
    end
  end








  def self.import_cadets(cadet_json_list)
    # Create the client with your credentials
    client = OAuth2::Client.new(ENV['UID_42'], ENV['SECRET_42'], site: "https://api.intra.42.fr")
    # Get an access token
    token = client.client_credentials.get_token    
    # cursus_id: 1 => 42 cursus, cursus_id: 4 => picine c cursus
    valid_cursus = [1]

    Parallel.each( -> { cadet_json_list.pop || Parallel::Stop }, in_threads: 40) do |hash|
      begin
          cadet_json = token.get("/v2/users/#{hash['id']}", ).parsed
          update = "login: #{cadet_json['login']}, name: #{cadet_json["first_name"] + " " + cadet_json["last_name"]}, email: #{cadet_json['email']}"
          if cadet_json['staff?'] == false
            cadet = Cadet.new
            cadet_json['cursus_users'].each do |cursus|
              update += ", cursus: #{cursus['cursus_id']}"    
              if cursus['cursus_id'].in?(valid_cursus)
                Cadet.collect_cadet_info!(cadet, cadet_json)                
              end              
            end  
          end
          puts update          

      rescue StandardError => e        
          print "\n"
          puts "error in Cadet.import_cadets"          
          puts e
          print "\n"
      end
    end
  end



end
