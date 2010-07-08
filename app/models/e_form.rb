class EForm < ActiveRecord::Base
  has_attachment :storage => :file_system, :path_prefix => 'public/data'
  validates_as_attachment
  validates_uniqueness_of :filename

  belongs_to :creator, :class_name => 'User', :foreign_key => 'created_by'

  def full_filename(thumbnail=nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end

  def uploaded_data=(file_data)
    return nil if file_data.nil? || file_data.size == 0
    self.content_type = file_data.content_type

    #Changing the below line to add a UUID to the filename so that all filenames will be unique (stored in same folder)
    self.filename = (UUIDTools::UUID.timestamp_create().to_s + file_data.original_filename) if respond_to?(:filename)
    if file_data.is_a?(StringIO)
      file_data.rewind
      self.temp_data = file_data.read
    else
      self.temp_path = file_data
    end
  end

end
