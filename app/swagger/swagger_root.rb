# frozen_string_literal: true

require_relative 'v1/models/document_swagger'

class SwaggerRoot
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'API Documentation'
      key :description, 'API Documentation for the Rails API'
    end
    key :host, 'localhost:3000'
    key :basePath, '/api'
    key :schemes, ['http']
  end

  SWAGGERED_CLASSES = [
    V1::DocumentsControllerSwagger,
    DocumentSwagger,
    self
  ].freeze

  def self.swaggered_classes
    SWAGGERED_CLASSES
  end
end
