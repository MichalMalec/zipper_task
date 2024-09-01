class Document < ApplicationRecord
  has_one_attached :file

  belongs_to :user

  validates :title, presence: true
  validate :file_size_validation

  private

  def file_size_validation
    if file.attached? && file.blob.byte_size > 500.kilobytes
      errors.add(:file, 'size should be less than 5MB')
    elsif file.attached? == false
      errors.add(:file, 'must be attached')
    end
  end
end
