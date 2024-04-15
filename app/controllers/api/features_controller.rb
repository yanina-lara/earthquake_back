module Api
  class FeaturesController < ApplicationController
    DEFAULT_PER_PAGE = 1000
    
    def index
      if valid_mag_types?
        @features = Feature.where(mag_type: params[:mag_type])
      else
        @features = Feature.all
      end
      @features = paginate_features(@features)
  
      render json: {
        data: ActiveModel::Serializer::CollectionSerializer.new(@features, each_serializer: FeatureSerializer),
        pagination: pagination_data(@features)
      }
    end    

    private

    def pagination_data(collection)
      {
        current_page: collection.current_page,
        total: collection.total_entries,
        per_page: collection.per_page
      }
    end    

    def valid_mag_types?
      if params[:mag_type]
        mag_types = params[:mag_type].split(',')
        allowed_mag_types = ['md', 'ml', 'ms', 'mw', 'me', 'mi', 'mb', 'mlg']
    
        invalid_mag_types = mag_types - allowed_mag_types
        if invalid_mag_types.present?
          render json: { error: "Invalid mag_type values: #{invalid_mag_types.join(', ')}" }, status: :unprocessable_entity
          return false
        end

        true
      else
        false
      end
    end

    def paginate_features(features)
      features.paginate(page: params[:page], per_page: params[:per_page] || DEFAULT_PER_PAGE)
    end
  end
end
