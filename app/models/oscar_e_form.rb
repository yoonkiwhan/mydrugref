class OscarEForm < ActionWebService::Struct

  member :id,         :int
  member :created_at, :datetime
  member :creator,    :string
  member :name,       :string
  member :category,   :string
  member :url,        :string

end
