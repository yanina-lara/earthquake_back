require 'rest-client'
require 'json'

class EarthquakeDataService
  BATCH_SIZE = 1000
  URL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'.freeze

  def self.fetch_and_persist_data
    response = RestClient.get(URL)
    data = JSON.parse(response.body)
    
    Feature.transaction do
      data['features'].each_slice(BATCH_SIZE) do |batch|
        features_to_create = []
      
        batch.each do |feature|
          next if Feature.find_by(external_id: feature['id'])
          if valid_feature_data?(feature)
            features_to_create << feature_data(feature)
          else
            Rails.logger.warn "Incomplete data for the feature with ID #{feature['id']}. The feature was not created."
          end
        end
        Feature.create(features_to_create) unless features_to_create.empty?
      end
    end
  rescue RestClient::ExceptionWithResponse => e
    puts "Error fetching data from the API: #{e.response}"
  rescue StandardError => e
    Rails.logger.error "Error fetching or persisting seismic data: #{e.message}"
    raise e
  end

  private

  def self.valid_feature_data?(feature)
    feature['properties']['title'].present? &&
      feature['properties']['url'].present? &&
      feature['properties']['place'].present? &&
      feature['properties']['magType'].present? &&
      feature['geometry']['coordinates'][0].present? &&
      feature['geometry']['coordinates'][1].present?
  end

  def self.feature_data(feature)
    {
      external_id: feature['id'],
      magnitude: feature['properties']['mag'],
      place: feature['properties']['place'],
      time: Time.at(feature['properties']['time'] / 1000).utc.to_datetime,
      tsunami: feature['properties']['tsunami'],
      mag_type: feature['properties']['magType'],
      title: feature['properties']['title'],
      url: feature['properties']['url'],
      longitude: feature['geometry']['coordinates'][0],
      latitude: feature['geometry']['coordinates'][1]
    }
  end
end
