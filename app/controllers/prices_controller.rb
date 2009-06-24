class PricesController < PostsController

  def index
    super
    @posts = Price.paginate :page => params[:page], :order => 'created_by', :per_page => 20
  end

  def get_results_by_brand
    value = ('%' + params[:drugtext] + '%').gsub(' ', '%')     
    drugs = Drug.find(:all, :conditions => [ 'class_1=? AND LOWER(brand_name) LIKE ?', 'HUMAN', value.downcase], 
                      :select => 'brand_name, drug_identification_number, drug_code')
    @results = []
    drugs.each do |drug|
      code = Code.find_by_drug_code(drug.drug_code, :select => 'tc_atc, tc_atc_number')
      unless code.nil? or code.tc_atc_number.nil? or code.tc_atc_number == ''
        @results << {:atc_code => code.tc_atc_number, :atc_class => code.tc_atc, 
                     :ais => ActiveIngredient.find(:all, 
                                                   :conditions => {:drug_code => drug.drug_code }, 
                                                   :select => 'ingredient, strength, strength_unit'),
                     :brand_name => drug.brand_name, :din => drug.drug_identification_number,
                     :company => Company.find_by_drug_code(drug.drug_code, :select => 'company_name').company_name }
      end
    end
    if @results.empty?
      @results = 'None'
    end
    render :partial => 'results', :object => @results    
  end
  
  def get_results_by_ingredient
    value = ('%' + params[:drugtext] + '%').gsub(' ', '%')     
    ingredients = ActiveIngredient.find(:all, :conditions => [ 'LOWER(ingredient) LIKE ?', value.downcase],
                                        :select => 'ingredient, strength, strength_unit, drug_code')
    ingredients.delete_if{|a| a.code.nil?}
    grouped_ingredients = ingredients.group_by {|i| 
                          Drug.find_by_drug_code(i.drug_code, 
                                                 :select => 'drug_code, brand_name, drug_identification_number')
                                                 }
    @results = []
    grouped_ingredients.each do |drug, ingredients|
      code = Code.find_by_drug_code(drug.drug_code, :select => 'tc_atc, tc_atc_number')
      @results << {:atc_code => code.tc_atc_number, :atc_class => code.tc_atc, 
                   :ais => ingredients,
                   :brand_name => drug.brand_name, :din => drug.drug_identification_number,
                   :company => Company.find_by_drug_code(drug.drug_code, :select => 'company_name').company_name }
    end
    if @results.empty?
      @results = 'None'
    end
    render :partial => 'results', :object => @results    
  end
  
  def add_price_drug
    @price_drug = { :brand_name => params[:brand_name], :atc => params[:atc_code], :din => params[:din] }
    render :partial => 'price_drug', :object => @price_drug
  end

  def edit
    @edit_on = true
    @page_title = 'Edit Price'
  end
  
  private
    def model_name; 'Price'; end
  
end
