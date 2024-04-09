module Api
  module V1
    class FeaturesController < ApplicationController
      def index
        @features = Feature.all
        @features = @features.where(mag_type: params[:filters][:mag_type]) if params[:filters].present? && params[:filters][:mag_type].present?
        @features = @features.paginate(page: params[:page], per_page: [params[:per_page].to_i, 1000].min)
        
        transformed_features = @features.map do |feature|
          {
            id: feature.id,
            type: 'feature',
            attributes: {
              external_id: feature.external_id,
              magnitude: feature.magnitude,
              place: feature.place,
              time: feature.time,
              tsunami: feature.tsunami,
              mag_type: feature.mag_type,
              title: feature.title,
              coordinates: {
                longitude: feature.longitude,
                latitude: feature.latitude
              }
            },
            links: {
              external_url: feature.url
            }
          }
        end

        render json: {
          data: transformed_features,
          pagination: pagination_dict(@features)
        }
      end

      private

      def pagination_dict(object)
        {
          current_page: object.current_page,
          total: object.total_entries,
          per_page: object.per_page
        }
      end
    end
  end
end
