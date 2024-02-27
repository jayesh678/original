class Api::V1::SessionsController < ApplicationController
  
  skip_before_action :verify_authenticity_token
   protect_from_forgery with: :null_session
    skip_before_action :authenticate_user!
  def create
    user = User.find_by(email: params[:email])
      if user && user.valid_password?(params[:password])
      session[:user_id] = user.id
      render json: { status: 'success', message: 'Logged in successfully', data: user }, status: :ok
    else
      render json: { status: 'error', message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def index
  regular_expenses = Expense.joins(:category).where(categories: { category_type: "Regular" })
  # binding.pry 
  render json: { status: 'success', message: 'These are the regular expenses', data: regular_expenses.map(&:attributes) }, status: :ok
end

def index
  travel_expenses = Expense.includes(:category).where(categories: { category_type: "Travel"})
  render json: { status: 'success', message: "These are travel expenses", data: travel_expenses.map(&:attributes)}, status: :ok
end


   def destroy
    session.delete(:user_id)
    render json: { status: 'success', message: 'Logged out successfully' }, status: :ok
  end
end
