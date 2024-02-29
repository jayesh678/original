class FlowsController < ApplicationController
  def index
    @flows = Flow.all
    @user_id = params[:user_id]
    @expense_id = params[:expense_id]
  end

  def new
    @flow = Flow.new
    @user = User.find(params[:user_id])
    @expense = Expense.find(params[:expense_id])
    @initiator = @expense.flow.user_assigned_id
    @approver = @expense.flow.assigned_user_id
    @cancelled_by = @expense.flow.assigned_user_id
  end

  def create
    @expense = Expense.find(params[:expense_id])
    @flow = @expense.build_flow(flow_params)
    if @flow.save
      redirect_to user_expense_flows_path, notice: 'Flow was successfully created.'
    else  
      render :new
    end
  end

  def show
    @user_id = params[:user_id]
    @expense_id = params[:expense_id]
    @flow = Flow.find(params[:id])
    @user = User.find(params[:user_id])
    @expense = Expense.find(params[:expense_id])
    @initiator = @expense.flow.user_assigned_id
    @approver = @expense.flow.assigned_user_id
    @cancelled_by = @expense.flow.assigned_user_id
  end

  def edit 
    @flow = Flow.find(params[:id])
    @user = User.find(params[:user_id])
    @expense = Expense.find(params[:expense_id])
    @initiator = @expense.flow.user_assigned_id
    @approver = @expense.flow.assigned_user_id
    @cancelled_by = @expense.flow.assigned_user_id
  end

  def update
    @user = User.find(params[:user_id])
    @expense = Expense.find(params[:expense_id])
    @flow = Flow.find(params[:id])

    if @flow.update(flow_params)
      redirect_to user_expense_flows_path(@user, @expense), notice: 'Flow was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @flow = Flow.find(params[:id])
    @flow.destroy
    redirect_to user_expense_flows_path, notice: "Flow was successfully deleted."
  end

  private
  def flow_params
    params.require(:flow).permit(:user_assigned_id, :assigned_user_id, :start_date, :end_date)
  end
end
