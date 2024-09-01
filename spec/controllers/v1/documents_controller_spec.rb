require 'rails_helper'

RSpec.describe V1::DocumentsController, type: :controller do
  let(:user) { create(:user) }
  let(:document) { build(:document, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a list of documents for the current user' do
      documents = create_list(:document, 3, user: user)
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
      expect(assigns(:documents)).to match_array(documents)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new document and returns a success response' do
        allow_any_instance_of(V1::DocumentsController).to receive(:generate_random_password).and_return('password123')
        allow(ZipGenerator).to receive(:generate_zip_with_password).and_return('path/to/zip_file.zip')

        file = fixture_file_upload('sample_file.txt')
        post :create, params: { document: { title: 'Sample Document', file: file } }
        
        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body['title']).to eq('Sample Document')
        expect(response_body['download_link']).to include('/downloads/')
        expect(response_body['password']).to eq('password123')
        expect(Document.last.title).to eq('Sample Document')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new document and returns an error response' do
        file = fixture_file_upload('sample_file.txt')
        post :create, params: { document: { title: '', file: file } }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'private methods' do
    controller = V1::DocumentsController.new

    describe '#generate_random_password' do
      it 'generates a random password' do
        password = controller.send(:generate_random_password)
        expect(password).to be_present
        expect(password.length).to eq(16)
      end
    end

    describe '#generate_download_link' do
      it 'generates a valid download link' do
        allow(controller).to receive_message_chain(:request, :base_url).and_return('http://example.com')

        zip_file_path = 'path/to/zip_file.zip'
        expected_download_link = 'http://example.com/downloads/zip_file.zip'

        download_link = controller.send(:generate_download_link, zip_file_path)

        expect(download_link).to eq(expected_download_link)
      end
    end

    describe '#success_response' do
      it 'returns the correct success response format' do
        document = build(:document, title: 'Sample Document')
        download_link = 'http://example.com/downloads/zip_file.zip'
        password = 'password123'
        
        response = controller.send(:success_response, document, download_link, password)
        
        expect(response).to eq({
          title: 'Sample Document',
          download_link: download_link,
          password: password
        })
      end
    end
  end
end
