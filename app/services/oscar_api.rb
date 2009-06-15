class OscarApi < ActionWebService::API::Base
  api_method :fetch,
             :expects => [:string, [:string], :string, :bool],
             :returns => [[Oscarresult]]

  api_method :get_treatments,
             :expects => [:string, :string, :bool],
             :returns => [[Oscarresult]]
 
end
