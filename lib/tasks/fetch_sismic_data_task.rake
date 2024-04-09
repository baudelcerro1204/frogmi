namespace :fetch_sismic_data do
    desc "Fetch and persist sismic data"
    task :fetch => :environment do
      require 'net/http'
      require 'json'
  
      url = URI.parse('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
  
      request = Net::HTTP::Get.new(url.request_uri)
  
      response = http.request(request)
  
      if response.code == '200'
        data = JSON.parse(response.body)
  
        data['features'].each do |feature|
          next unless feature['properties']['title'] && feature['properties']['url'] && feature['properties']['place'] && feature['properties']['magType'] && feature['geometry']['coordinates'][0] && feature['geometry']['coordinates'][1]
  
          Feature.find_or_create_by(external_id: feature['id']) do |f|
            f.magnitude = feature['properties']['mag']
            f.place = feature['properties']['place']
            f.time = Time.at(feature['properties']['time'] / 1000)
            f.tsunami = feature['properties']['tsunami']
            f.mag_type = feature['properties']['magType']
            f.title = feature['properties']['title']
            f.longitude = feature['geometry']['coordinates'][0]
            f.latitude = feature['geometry']['coordinates'][1]
            f.url = feature['properties']['url']
          end
        end
      else
        puts "Error: #{response.code} #{response.message}"
      end
    end
  end
  