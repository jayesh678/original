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
  before_action :create_common_flow, only: [:create]

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
    # binding.pry
    @expense = @user.expenses.new(expense_params)
    @expense.status = "initiated"
    
  
    # Associate the common flow with the expense
    @expense.flow_id = @common_flow.id
    
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

  def update
    if @expense.update(expense_params)
      flash[:notice] = 'Expense was successfully updated'
      redirect_to user_expenses_path(@user)
    else
      render :edit
    end
  end

  def approve
    if @expense.update(status: :approved)
      redirect_to user_expenses_path(@user), notice: 'Expense approved successfully.'
    else
      redirect_to user_expenses_path(@user), alert: 'Failed to approve expense.'
    end
  end

  def cancel
    if @expense.update(status: :cancelled)
      redirect_to user_expenses_path(@user), notice: 'Expense cancelled successfully.'
    else
      redirect_to user_expenses_path(@user), alert: 'Failed to cancel expense.'
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

  def create_common_flow
    @common_flow = Flow.find_or_create_by(user_assigned_id: current_user.id)
    @common_flow.update(assigned_user_id: params[:expense][:assigned_user_id])
  end
  
  def expense_params
    params.require(:expense).permit(:number_of_people, :application_name, :total_amount, :date_of_application, :subcategory_id, :expense_date, :category_id, :start_date, :end_date, :source, :destination, :business_partner_id, :amount, :tax_amount, :status, :receipt, :description, :application_number)
  end
end
