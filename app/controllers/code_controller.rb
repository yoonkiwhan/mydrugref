class CodeController < ApplicationController

   def search
    @query = params[:query]
    @total, @codes = Code.full_text_search(@query, :page => (params[:page]||1))
    @pages = pages_for(@total)
    render :partial => "search", :layout => true
  end
  
  def findatc 
    @drug_code = CdDrugProduct.find_by_brand_name(params[:brand_name]).drug_code
    render :layout => false
    render_text "<li>" + @drug_code + "</li>"
  end

end
