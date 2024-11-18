require 'rails_helper'

RSpec.describe "Api::V1::ShortenedUrls", type: :request do
  let(:valid_headers) { { "Authorization" => ENV['API_TOKEN'] } }
  let(:valid_params) { { shortened_url: { long_url: "https://example.com" } } }

  describe "POST /api/v1/shortened_urls" do
    it "creates a short URL" do
      post api_v1_shortened_urls_path, params: valid_params, headers: valid_headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['short_url']).to be_present
    end

    it "returns unauthorized if token is missing" do
      post api_v1_shortened_urls_path, params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
