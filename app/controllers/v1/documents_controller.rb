class V1::DocumentsController < ApplicationController
  def index
    @documents = documents
    render json: @documents, status: :ok
  end
  
  def create
    document = build_document

    if document.save
      handle_successful_save(document)
    else
      handle_failed_save(document)
    end
  end
  
  private

  def documents
    current_user.documents
  end

  def build_document
    current_user.documents.build(document_params)
  end

  def document_params
    params.require(:document).permit(:title, :file)
  end

  def handle_successful_save(document)
    password = generate_random_password
    zip_file_path = ZipGenerator.generate_zip_with_password(document, password)
    download_link = generate_download_link(zip_file_path)

    render json: success_response(document, download_link, password), status: :created
  end

  def handle_failed_save(document)
    render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
  end

  def generate_random_password
    SecureRandom.hex(8)
  end

  def generate_download_link(zip_file_path)
    "#{request.base_url}/downloads/#{File.basename(zip_file_path)}"
  end

  def success_response(document, download_link, password)
    {
      title: document.title,
      download_link: download_link,
      password: password
    }
  end
end
