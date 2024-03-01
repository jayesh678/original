class VendorMastersController < ApplicationController
  before_action :set_vendor_master, only: [:show]

  def index
    @vendor_masters = VendorMaster.all
  end

  def new 
    @vendor_master = VendorMaster.new
  end

  def create
    @vendor_master = VendorMaster.new(vendor_master_params)
    if @vendor_master.save
      redirect_to new_business_partner_path(@business_partner)
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @business_partners = @vendor_master.business_partners
  end



  private

  def set_vendor_master
    @vendor_master = VendorMaster.find(params[:id])
  end

  def vendor_master_params
    params.require(:vendor_master).permit(:customer_code, :customer_name, :corporate_number, :invoice_number)
end
end

