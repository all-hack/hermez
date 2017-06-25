class CadetController < ApplicationController

  def new
    @cadet = Cadet.new
  end
   
  def create
    @cadet = Cadet.new
    
    @cadet.name = params[:name].downcase
    @cadet.login = params[:login].downcase
    @cadet.email = params[:login].downcase + '@student.42.us.org'
    @cadet.mails_received = 0

    if @cadet.save      
      redirect_to cadet_path, :flash => { :notice => "Cadet, #{@cadet.login} successfully added to datastore"}
    else
      redirect_to cadet_path, :flash => { :error => "Cadet, #{@cadet.login} not added to datastore" }
    end

  end


  def import_cadets_fremont
    # Create the client with your credentials
    client = OAuth2::Client.new(ENV['UID_42'], ENV['SECRET_42'], site: "https://api.intra.42.fr")
    # Get an access token
    token = client.client_credentials.get_token

    page_num = 0
    page_og = page_num
    page_size = 100
    page_limit = 9999
    cadet_count = Cadet.count

    puts "current number of cadets: #{cadet_count}"
    while (page_num < page_limit)
      begin
        cadet_json_list = token.get("/v2/campus/7/users", params: {page: {number: page_num, size: page_size}}).parsed          
        print "\n"
        puts "page number: #{page_num}"
        puts cadet_json_list          
        print "\n"
        
        if cadet_json_list.empty? == true
          puts "response from api empty"
          break
        end
        
        hash = Cadet.import_cadets(cadet_json_list)
        page_num += 1

      rescue StandardError => e        
        puts "error in cadet#import_cadets_fremont"
        puts e
      end
    end    

    updated_cadet_count = 0
    Cadet.uncached do 
      updated_cadet_count = Cadet.count
    end
    redirect_to cadet_path, :flash => { :notice => "#{updated_cadet_count - cadet_count} cadets imported, #{page_num - page_og} pages of #{page_size} entries pulled" }
  end


end
