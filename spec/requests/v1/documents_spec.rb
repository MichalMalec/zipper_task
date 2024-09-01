# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Documents', type: :request do
  let(:user) { create(:user) }

  before do
    post user_session_path, params: { user: { email: user.email, password: 'password123' } }
    @auth_token = response.headers['Authorization']
  end

  describe 'GET /v1/documents' do
    it 'returns a list of documents' do
      create_list(:document, 3, user:)

      get '/v1/documents', headers: { 'Authorization' => @auth_token }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'POST /v1/documents' do
    context 'with valid attributes' do
      it 'creates a new document and returns a success response' do
        allow(ZipGenerator).to receive(:generate_zip_with_password).and_return('path/to/zip_file.zip')
        allow_any_instance_of(V1::DocumentsController).to receive(:generate_random_password).and_return('password123')

        file = fixture_file_upload('sample_file.txt')

        post '/v1/documents', params: { document: { title: 'Sample Document', file: } },
                              headers: { 'Authorization' => @auth_token }

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body['title']).to eq('Sample Document')
        expect(response_body['download_link']).to include('/downloads/')
        expect(response_body['password']).to eq('password123')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new document and returns an error response' do
        file = fixture_file_upload('sample_file.txt')

        post '/v1/documents', params: { document: { title: '', file: } },
                              headers: { 'Authorization' => @auth_token }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end
end
