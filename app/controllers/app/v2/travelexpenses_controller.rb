class Api::V2::TravelexpensesController < ApplicationController
  skip_before_action :verify_authenticity_token
   protect_from_forgery with: :null_session
    skip_before_action :authenticate_user!

  def index
    @travel_expenses = Expense.find_by(catetgory_type: "Travel")
    respond json: @travel_expenses
end
