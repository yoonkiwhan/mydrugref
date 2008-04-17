class Oscarcom < ActionWebService::Struct
  member :id,         :int
  member :created_at, :datetime
  member :updated_at, :datetime
  member :created_by, :int
  member :updated_by, :int
  member :body,       :text
  member :name,       :string
  member :post_id,    :int
  member :goat,       :bool
  member :author,     :string
end
