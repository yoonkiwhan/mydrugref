class DrugsController < ApplicationController

   def index
    @page_title = "Health Canada Database"
    value = params[:drugtext]
    if value.nil?
      conditions = nil
    else
      add_percents(value)
      conditions = 'LOWER(brand_name) LIKE ?', value.downcase
    end
    @drugs = Drug.paginate :page => params[:page], :conditions => conditions, :order => 'brand_name ASC', 
                           :per_page => 20
    if request.xhr?
      render :update do |page|
        page[:drugtable].replace :partial => 'table'
      end
    end
   end
   
   def show
    @drug = Drug.find(params[:id])
    @price_drs = DrugRef.find(:all, :conditions => {:label => 'Price', :drug_identification_number => @drug.id})
    @prices = []
    for dr in @price_drs
      @prices << dr.post
    end
   end
 
end