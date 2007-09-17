class DrugsController < ApplicationController
   def hcdb
    @page_title = "Health Canada Database"
   end
  
   def search
    @query = params[:query]
    @total, @drugs = Drug.full_text_search(@query, :page => (params[:page]||1))
    @pages = pages_for(@total)       
    render :partial => "search", :layout => true
  end
 
  def findatc
    @rue = params[:name]
    @total, @drugs = Drug.full_text_search(@rue)
    render :partial => "atc"
  end
 
end
