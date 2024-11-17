# app/controllers/api/v1/shortened_urls_controller.rb
module Api
  module V1
    class ShortenedUrlsController < ApplicationController
      before_action :authenticate_token!

      def create
        url = Url.new(url_params)
        url.short_url = SecureRandom.hex(4) # Generate unique short URL

        if url.save
          render json: { short_url: url.short_url, long_url: url.long_url }, status: :created
        else
          render json: { errors: url.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def url_params
        params.require(:shortened_url).permit(:long_url)
      end

      def authenticate_token!
        token = request.headers['Authorization']
        render json: { error: 'Unauthorized' }, status: :unauthorized unless token == ENV['API_TOKEN']
      end
    end
  end
end
