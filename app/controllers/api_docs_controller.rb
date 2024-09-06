# frozen_string_literal: true

# app/controllers/api_docs_controller.rb
class ApiDocsController < ActionController::Base
  include Swagger::Blocks

  def index
    render json: Swagger::Blocks.build_root_json(SwaggerRoot.swaggered_classes)
  end
end
