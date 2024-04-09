# app/serializers/feature_serializer.rb
class FeatureSerializer < ActiveModel::Serializer
    attributes :id, :type, :attributes, :links
  
    def type
      'feature'
    end
  
    def attributes
      {
        external_id: object.external_id,
        magnitude: object.magnitude,
        place: object.place,
        time: object.time.to_s,
        tsunami: object.tsunami,
        mag_type: object.mag_type,
        title: object.title,
        coordinates: {
          longitude: object.longitude,
          latitude: object.latitude
        }
      }
    end
  
    def links
      {
        external_url: object.url
      }
    end
  end
  