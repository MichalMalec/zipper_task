class V1::DocumentsController < ApplicationController
    def create
        @document = Document.new(document_params)
    
        if @document.save
          render json: { id: @document.id, title: @document.title, file_url: url_for(@document.file) }, status: :created
        else
          render json: { errors: @document.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      private
    
      def document_params
        params.require(:document).permit(:title, :file)
      end
end
