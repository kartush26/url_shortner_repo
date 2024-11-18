# spec/requests/api/v1/shortened_urls_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/shortened_urls', type: :request do
  path '/api/v1/shortened_urls' do
    post('create shortened url') do
      tags 'ShortenedUrls'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authorization, in: :header, type: :string, required: true, description: 'API Token'
      parameter name: :shortened_url, in: :body, schema: {
        type: :object,
        properties: {
          long_url: { type: :string, example: 'https://example.com' }
        },
        required: ['long_url']
      }

      response(201, 'created') do
        let(:Authorization) { ENV['API_TOKEN'] } # This sets the Authorization header
        let(:shortened_url) { { shortened_url: { long_url: 'https://example.com' } } }

        run_test! do |response|
          expect(JSON.parse(response.body)['short_url']).to be_present
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil } # Simulates a missing token
        let(:shortened_url) { { shortened_url: { long_url: 'https://example.com' } } }

        run_test! do |response|
          expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
        end
      end
    end
  end
end
