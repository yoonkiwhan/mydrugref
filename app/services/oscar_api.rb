class OscarApi < ActionWebService::API::Base
  api_method :fetch,
             :expects => [:string, [:string], :string, :bool],
             :returns => [[Oscarresult]]

  api_method :get_treatments,
             :expects => [:string, :string, :bool],
             :returns => [[Oscarresult]]
             
  api_method :get_guideline_ids,
             :expects => [:int],
             :returns => [[:int]]
             
  api_method :get_guidelines,
             :expects => [[:int]],
             :returns => [[Oscarresult]]
 
end
