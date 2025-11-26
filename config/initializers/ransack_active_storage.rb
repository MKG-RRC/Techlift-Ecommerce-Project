# Allow Ransack to search ActiveStorage classes without errors
Rails.application.config.to_prepare do

  # ActiveStorage::Attachment allowlist
  ActiveStorage::Attachment.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      ["id", "name", "record_id", "record_type", "blob_id", "created_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["blob", "record"]
    end
  end

  # ActiveStorage::Blob allowlist
  ActiveStorage::Blob.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      ["id", "filename", "content_type", "metadata", "byte_size", "checksum", "created_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["attachments"]
    end
  end

end
