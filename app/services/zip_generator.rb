require 'zip'

class ZipGenerator
    def self.generate_zip(document)
      download_dir = Rails.root.join('public', 'downloads')
      Dir.mkdir(download_dir) unless File.directory?(download_dir)

      file_name = "#{document.title.parameterize}.zip"
      file_path = Rails.root.join('public', 'downloads', file_name)

      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        original_file = document.file.download
        original_filename = document.file.filename.to_s

        zipfile.get_output_stream(original_filename) do |f|
        f.write(original_file)
        end
      end

      file_path
    end
end