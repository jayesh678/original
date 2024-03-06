class ExpensesController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    render "shared/access_denied", status: :forbidden
  end

  load_and_authorize_resource 

  before_action :find_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :load_categories, only: [:new, :create, :update]
  before_action :set_subcategories, only: [:new, :create, :update, :edit]
  before_action :set_business_partners, only: [:new, :create, :update]
  before_action :find_expense, only: [:edit, :update, :destroy, :approve, :cancel]
  # before_action :create_common_flow, only: [:create]

def index
  if current_user.super_admin?
    @expenses = Expense.includes(:user).where(users: { company_id: current_user.company_id })
  elsif current_user.admin?
    @expenses = Expense.includes(:user).where(user_id: current_user.company.users.where.not(role_id: Role.find_by(role_name: 'super_admin').id))
  else
    @expenses = current_user.expenses
  end
  @expenses = @expenses.paginate(page: params[:page], per_page: 5)
end

def create
  @expense = @user.expenses.new(expense_params)
  @expense.status = "initiated"

  # Find or create the common flow for the user's company
  common_flow = Flow.find_or_create_by(company_id: current_user.company_id)

  # Associate the common flow with the expense
  @expense.flow = common_flow

  # Set the user_assigned_id of the flow to the user who creates the expense
  common_flow.update(user_assigned_id: @expense.initiator_id)

  if @expense.save
    redirect_to user_expenses_path(@user), notice: 'Expense was successfully created.'
  else
    render :new
  end
end







  
  def new
    @expense = @user.expenses.build
    @users = current_user.company.users
  end

  def edit
    @categories = Category.all
    @regular_subcategories = Category.find_by(category_type: 'Regular')&.subcategories
    @travel_subcategories = Category.find_by(category_type: 'Travel')&.subcategories
    @business_partners = BusinessPartner.all
    @users = current_user.company.users
  end

  # def update
  #   if @expense.update(expense_params)
  #     flash[:notice] = 'Expense was successfully updated'
  #     redirect_to user_expenses_path(@user)
  #   else
  #     render :edit
  #   end
  # end

  def update
    # binding.pry
    @expense = Expense.find(params[:id])
    @flow = Flow.find_by(user_assigned_id: @expense.initiator_id) # Assuming user_assigned_id is associated with Expense as initiator_id
  
    if current_user.id == @flow.assigned_user_id
      if params[:approve_button]
        update_status_and_redirect(:approved, 'Expense was successfully approved.')
        ExpenseMailer.notify_super_admin(@expense, current_user).deliver_now
      elsif params[:cancel_button]
        update_status_and_redirect(:cancelled, 'Expense was successfully cancelled.')
      else
        update_expense('Expense was successfully updated')
      end
    else
      update_expense('Expense was successfully updated')
    end
  end
  

  def approve
    if @expense.update(status: :approved)
      redirect_to user_expenses_path, notice: 'Expense approved successfully.'
    
    else
      redirect_to user_expenses_path, alert: 'Failed to approve expense.'
    end
  end

  def cancel
    # binding.pry
    if @expense.update(status: :cancelled)
      redirect_to user_expenses_path, notice: 'Expense cancelled successfully.'
    else
      redirect_to user_expenses_path, alert: 'Failed to cancel expense.'
    end
  end

  def show
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
  end

  def destroy
    if @expense.destroy
      redirect_to user_expenses_path(@user), notice: 'Expense was successfully destroyed.'
    else
      redirect_to user_expense_path(@user, @expense), alert: 'Failed to destroy expense.'
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id]) if params[:user_id].present?
  end

  def set_business_partners
    @business_partners = BusinessPartner.all
  end

  def load_categories
    @categories = Category.all
  end

  def set_subcategories
    @subcategories = Subcategory.all
    @regular_subcategories = Category.find_by(category_type: 'Regular')&.subcategories
    @travel_subcategories = Category.find_by(category_type: 'Travel')&.subcategories
  end

  def find_expense
    @expense = Expense.find(params[:id])
  end

  # def create_common_flow
  #   @common_flow = Flow.find_or_create_by(user_assigned_id: current_user.id)
  #   @common_flow.update(assigned_user_id: params[:expense][:assigned_user_id])
  # end

  def update_status_and_redirect(status, notice_message)
    if @expense.update(status: status)
      redirect_to user_expenses_path(current_user), notice: notice_message
    else
      render :edit
    end
  end

  def update_expense(success_message = 'Expense was successfully updated')
    if @expense.update(expense_params)
      flash[:notice] = success_message
      redirect_to user_expenses_path(current_user)
    else
      render :edit
    end
  end

  def send_daily_expenses_report_to_super_admin
    super_admin = User.find_by(role: Role.find_by(role_name: 'super_admin'))
    if super_admin
      report = Expense.approved_expenses_report
      ExpenseMailer.approved_expenses_report(super_admin, report).deliver_now
      puts "Daily expenses report sent to super admin successfully."
    else
      puts "Super admin not found."
    end
  end

  
  def expense_params
    params.require(:expense).permit(:number_of_people, :application_name, :total_amount, :date_of_application, :subcategory_id, :expense_date, :category_id, :start_date, :end_date, :source, :destination, :business_partner_id, :amount, :tax_amount, :status, :receipt, :description, :application_number, :initiator_id)
  end
end