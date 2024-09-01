class ZipGenerator
    DOWNLOAD_DIR = Rails.root.join('public', 'downloads')
    TMP_DIR = Rails.root.join('tmp')
  
    def self.generate_zip_with_password(document, password)
      ensure_directory_exists(DOWNLOAD_DIR)
  
      file_name = generate_zip_file_name(document.title)
      file_path = DOWNLOAD_DIR.join(file_name)
  
      delete_if_exists(file_path)
  
      original_file_path = save_original_file_to_temp(document)
  
      create_encrypted_zip(file_path, original_file_path, password)
  
      delete_if_exists(original_file_path)
  
      file_path
    end
  
    private
  
    def self.ensure_directory_exists(dir)
      Dir.mkdir(dir) unless File.directory?(dir)
    end
  
    def self.generate_zip_file_name(title)
      "#{title.parameterize}.zip"
    end
  
    def self.delete_if_exists(file_path)
      File.delete(file_path) if File.exist?(file_path)
    end
  
    def self.save_original_file_to_temp(document)
      file_path = TMP_DIR.join(document.file.filename.to_s)
      File.open(file_path, 'wb') do |file|
        file.write(document.file.download)
      end
      file_path
    end
  
    def self.create_encrypted_zip(zip_file_path, original_file_path, password)
      system("zip -j -P #{password} #{zip_file_path} #{original_file_path}")
    end
  end