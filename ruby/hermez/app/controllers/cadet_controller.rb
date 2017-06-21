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

    page_num = 1
    page_size = 100
    page_limit = 100
    flag = true
    
    #success, fail, total
    results = [0, 0, 0]
    while (page_num < page_limit)
      begin
          cadet_json_list = token.get("/v2/campus/7/users", params: {page: {number: page_num, size: page_size}}).parsed          
          puts cadet_json_list          
          hash = Cadet.import_cadets(cadet_json_list)
          results[0] += hash[0]
          results[1] += hash[1]
          results[2] += hash[2]
          page_num += 1
      rescue StandardError => e        
          puts "error in cadet#import_cadets_fremont"
          puts e
          break     
      end
    end    

    redirect_to cadet_path, :flash => { :notice => "Import results: success: #{results[0].to_s}, failed: #{results[1].to_s}, total: #{results[2].to_s}" }
  end


end
