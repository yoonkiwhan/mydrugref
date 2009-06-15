class PricesController < PostsController
  
def index
end

def create    
    @drug = Drug.find(params[:drug_identification_number])
    @price = Price.new(params[:price])
    @price.name = "Price of #{@drug.brand_name}"
    @price.creator = current_user
    if @price.save
    @dr = DrugRef.new({:drug_identification_number => @drug.drug_identification_number, 
		       :post_id => @price.id, :label => 'Price'})
    @dr.save
    flash[:notice] = "Price saved."
    redirect_to :back
    else
	flash[:notice] = "Price could not be saved."
	redirect_to :back
    end
end

  def edit
    @drug = Drug.find params[:drug_identification_number]
    @price = Price.find(params[:id])
  end
  
  def update
      @drug = Drug.find params[:drug_identification_number]
      @price = Price.find_by_id(params[:id])
      if @price.update_attributes(params[:price])
          flash[:notice] = "Your changes were saved."
          redirect_to drug_url(:id => @drug)        
      
      else
      render  :action => 'edit'
      end
    end
  
  def destroy
    @drug = Drug.find params[:drug_identification_number]
    @price = Price.find_by_id(params[:id])
    @price.destroy
    flash[:notice] = "Price deleted."
    redirect_to drug_url(:id => @drug)
  end
  
  def show
    @drug = Drug.find(params[:drug_identification_number])
    @price = Price.find params[:id]
  end
  
end
