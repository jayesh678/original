class ExpensesController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    render "shared/access_denied", status: :forbidden
  end
  load_and_authorize_resource
  
  before_action :find_user
  before_action :load_categories, only: [:new, :create, :update]
  before_action :set_subcategories, only: [:new, :create, :update]
  before_action :set_business_partners, only: [:new, :create, :update]
  before_action :find_expense, only: [:edit, :update, :destroy]

  def index
    if current_user.super_admin? 
      @expenses = Expense.includes(:user).all
    elsif current_user.admin?
      @expenses = Expense.includes(:user).where.not(user_id: User.where(role: Role.find_by(role_name: 'super_admin')).pluck(:id))
    else
      @user = current_user
      @expenses = current_user.expenses
    end
    @expenses = @expenses.paginate(page: params[:page], per_page: 5)
  end

  def create
    @subcategories = Subcategory.all
    @expense = current_user.expenses.new(expense_params)
    @expense.status = "initiated"
    
    if @expense.save
      flow = Flow.find_or_create_by(user_assigned_id: current_user.id)
      @expense.update(flow_id: flow.id)
      
      if @expense.flow_id.present?
        flow = Flow.find_by(id: @expense.flow_id)
        if flow.present? && flow.assigned_user_id.present?
          ExpenseMailer.notify_assigned_user(flow.id).deliver_now
        end
      end
      redirect_to user_expenses_path, notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
  end

  def new
    @expense = Expense.new
    @flow = Flow.find_by(user_assigned_id: user_assigned_id)
  end

  def edit
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
    @flow = Flow.find_by(user_assigned_id: user_assigned_id)
    @categories = Category.all
    @regular_subcategories = Category.find_by(category_type: 'Regular')&.subcategories
    @travel_subcategories = Category.find_by(category_type: 'Travel')&.subcategories
    @business_partners = BusinessPartner.all
    @subcategories = Subcategory.all
  end

  def update
    @expense = Expense.find(params[:id])
    @flow = Flow.find_by(user_assigned_id: @expense.user_id)
    
    if current_user.id == @flow.assigned_user_id
      if params[:approve_button]
        update_status_and_redirect(:approved, 'Expense was successfully approved.')
        ExpenseMailer.notify_super_admin(@expense).deliver_now
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
    @expense = Expense.find(params[:id])
    if @expense.update(status: :approved)
      redirect_to user_expenses_path, notice: 'Expense approved successfully.'
    else
      redirect_to user_expenses_path, alert: 'Failed to approve expense.'
    end
  end

  def cancel
    @expense = Expense.find(params[:id])
    if @expense.update(status: :cancelled)
      redirect_to user_expenses_path, notice: 'Expense cancelled successfully.'
    else
      redirect_to user_expenses_path, alert: 'Failed to cancel expense.'
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    if @expense.destroy
      redirect_to user_expenses_path(user_id: current_user.id), notice: 'Expense was successfully destroyed.'
    else
      redirect_to user_expense_path(user_id: current_user.id, id: @expense.id), alert: 'Failed to destroy expense.'
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
    @expense = @user.expenses.find(params[:id])
  end

  def user_assigned_id
    Flow.pluck(:user_assigned_id)
  end

  def assigned_user_id
    Flow.pluck(:assigned_user_id)
  end

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
    params.require(:expense).permit(:number_of_people, :application_name, :total_amount, :date_of_application, :subcategory_id, :expense_date, :category_id, :start_date, :end_date, :source, :destination, :business_partner_id, :amount, :tax_amount, :status, :receipt, :description, :application_number)
  end
end
