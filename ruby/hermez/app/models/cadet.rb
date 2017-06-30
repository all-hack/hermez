class Cadet < ApplicationRecord
  include PgSearch
  validates :login, presence: true, uniqueness: true
  filterrific(    
    available_filters: [:search_query]
  )
  pg_search_scope :search_query, against: [:name, :login], :using => { :tsearch => {:prefix => true}}  

  scope :most_mail, lambda {
    # puts Cadet.maximum('mails_received')
    Cadet.order('mails_received desc').limit(10)
  }

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



  def self.piscine_validation(cadet_json)    
    # puts "0"
    piscine_month = cadet_json['pool_month'].downcase
    # puts "2"
    piscine_year = cadet_json['pool_year'].downcase
    # puts "3"
    cur_month = Date::MONTHNAMES[Date.current.month].downcase
    last_month = if Date.current.month > 1 then Date.current.month - 1 else 12 end
    last_month = Date::MONTHNAMES[last_month].downcase
    nxt_month = if Date.current.month < 12 then Date.current.month + 1 else 1 end
    nxt_month = Date::MONTHNAMES[nxt_month].downcase
    # puts "4"    
    cur_year =  Date.current.year.to_s

    puts "login: #{cadet_json['login']}"
    puts "piscine_month: #{piscine_month}"
    puts "piscine_year: #{piscine_year}"
    puts "cur_month: #{cur_month}"
    puts "last_month: #{last_month}"
    puts "nxt_month: #{nxt_month}"
    puts "cur_year: #{cur_year}"

    if (
      (piscine_month == cur_month or 
        piscine_month == last_month or
        piscine_month == nxt_month) and 
      (piscine_year == cur_year or 
        (piscine_month == last_month and piscine_year == cur_year - 1) or
        (piscine_month == nxt_month and piscine_year == cur_year + 1)
      )
    )
      return true
    else
      return false
    end
    
  end

  def self.import_cadets(cadet_json_list)
    # Create the client with your credentials
    client = OAuth2::Client.new(ENV['UID_42'], ENV['SECRET_42'], site: "https://api.intra.42.fr")
    # Get an access token
    token = client.client_credentials.get_token    
    # cursus_id: 1 => 42 cursus, cursus_id: 4 => picine c cursus
    valid_cursus = [1, 4]

    sql = "delete from cadets where piscine=true"
    records_array = ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.clear_all_connections!
    puts "old piscine users deleted!"

    Parallel.each( -> { cadet_json_list.pop || Parallel::Stop }, in_threads: 40) do |hash|
      begin
          cadet_json = token.get("/v2/users/#{hash['id']}", ).parsed
          update = "login: #{cadet_json['login']}, name: #{cadet_json["first_name"] + " " + cadet_json["last_name"]}, email: #{cadet_json['email']}"
          puts cadet_json_list
          if cadet_json['staff?'] == false
            cadet = Cadet.new
            cadet_json['cursus_users'].each do |cursus|
              update += ", cursus: #{cursus['cursus_id']}"    
              if cursus['cursus_id'].in?(valid_cursus)
                if cursus['cursus_id'] == 1
                  cadet.piscine = false                         
                elsif Cadet.piscine_validation(cadet_json)
                  cadet.piscine = true                                    
                else
                  puts "skipping #{cadet_json['login']}"
                  next
                end
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
