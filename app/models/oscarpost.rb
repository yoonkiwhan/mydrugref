class Oscarpost < ActionWebService::Struct
  member :id,   :int
  member :name, :string
  member :body, :text
  member :atc,  :string