class V1::DocumentsControllerSwagger
    include Swagger::Blocks
  
    swagger_path '/v1/documents' do
      operation :get do
        key :summary, 'Get a list of documents'
        key :description, 'Returns a list of documents belonging to the current user'
        key :operationId, 'getDocuments'
        key :produces, ['application/json']
        key :tags, ['Documents']
  
        response 200 do
          key :description, 'List of documents'
          schema type: :array do
            items do
              key :'$ref', :Document
            end
          end
        end
      end
  
      operation :post do
        key :summary, 'Create a new document'
        key :description, 'Creates a new document and returns download link with a password'
        key :operationId, 'createDocument'
        key :produces, ['application/json']
        key :tags, ['Documents']
  
        parameter name: :document, in: :body, required: true, description: 'Document to create' do
          schema do
            key :'$ref', :DocumentInput
          end
        end
  
        response 201 do
          key :description, 'Document created successfully'
          schema do
            key :'$ref', :DocumentOutput
          end
        end
  
        response 422 do
          key :description, 'Validation errors'
          schema do
            key :'$ref', :Errors
          end
        end
      end
    end
  end
  