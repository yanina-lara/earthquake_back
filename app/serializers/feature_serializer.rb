class FeatureSerializer < ActiveModel::Serializer
  attribute :id
  attribute :type, key: :type
  attribute :attributes do
    {
      external_id: object.external_id,
      magnitude: object.magnitude,
      place: object.place,
      time: object.time,
      tsunami: object.tsunami,
      mag_type: object.mag_type,
      title: object.title,
      coordinates: {
        longitude: object.longitude,
        latitude: object.latitude
      }
    }
  end

  attribute :links do
    {
      external_url: object.url
    }
  end
  
  def type
    object.type
  end
end
