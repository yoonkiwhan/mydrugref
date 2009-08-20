class EFormsController < ApplicationController
  before_filter :find_post, :only => [ :show, :edit, :update, :destroy ]

  def new
    @page_title = "New EForm"
    @e_form = EForm.new
  end

  def create
    @e_form = EForm.new(params[:e_form])
    @e_form.creator = current_user
    if @e_form.save
      flash[:notice] = 'Eform was successfully created.'
      redirect_to e_form_url(@e_form)
    else
      @page_title = "New EForm"
      render :action => :new
    end
  end
  
  def index
    @page_title = "EForms"
    @e_forms = EForm.all
  end

  def show
    @page_title = @eform.name
  end

  private

  def find_post
    begin
      @eform = EForm.find params[:id]
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid eform #{params[:id]}")
      flash[:notice] = "EForm does not exist"
      redirect_to e_forms_url
    end
  end

end
