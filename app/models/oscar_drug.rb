class OscarDrug < ActionWebService::Struct
  member :brand_name, :string
  member :drug_identification_number, :string
  member :atc,        :string
  member :label,      :string
end
