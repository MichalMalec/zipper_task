# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:user) { create(:user) }
  let(:valid_file) { fixture_file_upload('sample_file.txt', 'text/plain') }
  let(:large_file) { fixture_file_upload('large_file.txt', 'text/plain') }

  before do
    allow(large_file).to receive(:size).and_return(600.kilobytes)
  end

  context 'validations' do
    it 'is valid with a title and a file of valid size' do
      allow(valid_file).to receive(:size).and_return(400.kilobytes)
      document = Document.new(title: 'Sample Document', file: valid_file, user:)
      expect(document).to be_valid
    end

    it 'is invalid without a title' do
      document = Document.new(title: nil, file: valid_file, user:)
      expect(document).to_not be_valid
      expect(document.errors[:title]).to include("can't be blank")
    end

    it 'is invalid with a file size greater than 500 KB' do
      document = Document.new(title: 'Sample Document', file: large_file, user:)
      expect(document).to_not be_valid
      expect(document.errors[:file]).to include('size should be less than 5MB')
    end

    it 'is invalid without an attached file' do
      document = Document.new(title: 'Sample Document', user:)
      expect(document).to_not be_valid
      expect(document.errors[:file]).to include('must be attached')
    end
  end
end
