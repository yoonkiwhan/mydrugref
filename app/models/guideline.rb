class Guideline < Post
  include UUIDHelper

  def all_versions
    Guideline.find_all_by_uuid(self.uuid)
  end

end
