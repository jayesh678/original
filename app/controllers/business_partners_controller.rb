class BusinessPartnersController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    render "shared/access_denied", status: :forbidden
  end
  load_and_authorize_resource
  
  def index
    @business_partners = BusinessPartner.all
    @business_partners = BusinessPartner.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @business_partner = BusinessPartner.find(params[:id])
    flash[:alert] = 'Business Partner not found' if @business_partner.nil?
  end

  def edit
    @business_partner = BusinessPartner.find(params[:id])
    @customer_names = VendorMaster.pluck(:customer_name) 
  end
  
  def update
    @business_partner = BusinessPartner.find(params[:id])
    @customer_names = VendorMaster.pluck(:customer_name) 
  
    if @business_partner.update(business_partner_params)
      redirect_to business_partner_path(@business_partner), notice: 'Business Partner was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @business_partner = BusinessPartner.find(params[:id])
    @business_partner.destroy
    redirect_to business_partners_path, notice: 'Business Partner was successfully destroyed.'
  end

  def new
    @business_partner = BusinessPartner.new
    @customer_names = VendorMaster.pluck(:customer_name)
  end
  
  def create
    @business_partner = BusinessPartner.new(business_partner_params)
    @customer_names = VendorMaster.pluck(:customer_name)
  
    if @business_partner.save
      redirect_to business_partners_path, notice: "Business partner created successfully."
    else
      render :new
    end
  end

  def fetch_customer_details
    customer_name = params[:customer_name]
      @customer_details = VendorMaster.where(customer_name: customer_name)
      flash[:error] = "Vendor Master ID is missing."
    end
  
    respond_to do |format|
      format.js
    end

  private
  
  def business_partner_params
    params.require(:business_partner).permit(:vendor_master_id, :customer_name, :customer_code, :corporate_number, :invoice_number, :address, :postal_code, :telephone_number, :bank_name)
  end
end
