require 'json'
require 'open-uri'

namespace :earthquake do
  desc "Fetch and persist seismic data from USGS"
  task fetch_data: :environment do
    puts "Executing task to fetch and persist seismic data from USGS..."
    EarthquakeDataService.fetch_and_persist_data
    puts "Successful completion"
  end
end
