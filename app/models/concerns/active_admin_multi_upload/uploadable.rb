module ActiveAdminMultiUpload::Uploadable
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  module ClassMethods
    def allows_upload(attachment_name, gallery_class)
      code = <<-eoruby
        def to_jq_upload
          uploader = send("#{attachment_name}")
          thumb_url =  uploader.respond_to?(:thumb) ?  uploader.thumb.url : ""
          {
            "name" => uploader.original_filename,
            "size" => uploader.size,
            "url" => uploader.url,
            "thumbnail_url" => thumb_url,
            "delete_url" => destroy_upload_admin_#{gallery_class}_#{self.name.downcase.underscore}_url(self.send(#{gallery_class}).id, id, only_path: true),
            "id" => id,
            "delete_type" => "DELETE"
          }
        end
      eoruby
      class_eval(code)
    end
  end
end
