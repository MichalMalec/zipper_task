class V1::DocumentsController < ApplicationController
    def index
        @documents = current_user.documents
        render json: @documents, status: :ok
    end
    
    def create
        @document = current_user.documents.build(document_params)
    
        if @document.save
          zip_file_path = ZipGenerator.generate_zip(@document)
          download_link = "#{request.base_url}/downloads/#{File.basename(zip_file_path)}"
  
          render json: { id: @document.id, title: @document.title, download_link: download_link }, status: :created
        else
          render json: { errors: @document.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      private
    
      def document_params
        params.require(:document).permit(:title, :file)
      end
end
