class Api::V2::ExpensesController < ApplicationController
 skip_before_action :verify_authenticity_token
   protect_from_forgery with: :null_session
    skip_before_action :authenticate_user!
  def index
    binding.pry
    @regular_expenses =  Expense.find_by(category_type: "Regular")
    render json: @regular_expenses
  end
end
