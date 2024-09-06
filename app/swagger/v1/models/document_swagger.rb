# frozen_string_literal: true

class DocumentSwagger
  include Swagger::Blocks

  swagger_schema :Document do
    key :required, %i[id title file_url]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :title do
      key :type, :string
    end
    property :file_url do
      key :type, :string
      key :format, :uri
    end
  end

  swagger_schema :DocumentInput do
    key :required, %i[title file]
    property :title do
      key :type, :string
    end
    property :file do
      key :type, :string
      key :format, :binary
    end
  end

  swagger_schema :DocumentOutput do
    key :required, %i[title download_link password]
    property :title do
      key :type, :string
    end
    property :download_link do
      key :type, :string
      key :format, :uri
    end
    property :password do
      key :type, :string
    end
  end

  swagger_schema :Errors do
    property :errors do
      key :type, :array
      items do
        key :type, :string
      end
    end
  end
end
