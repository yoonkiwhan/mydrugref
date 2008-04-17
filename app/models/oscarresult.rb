class Oscarresult < ActionWebService::Struct
  member :id,         :int
  member :type,       :string
  member :created_at, :datetime
  member :updated_at, :datetime
  member :created_by, :int
  member :updated_by, :int
  member :body,       :text
  member :name,       :string
  member :atc,        :string
  member :drug2,      :string
  member :atc2,       :string
  member :effect,     :string
  member :evidence,   :string
  member :reference,  :string
  member :significance, :string
  member :news_source, :string
  member :news_date,  :string
  member :trusted,    :bool
  member :author, :string
  member :comments,  [Oscarcom]
end
