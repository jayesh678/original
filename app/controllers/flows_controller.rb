class FlowsController < ApplicationController
  before_action :authenticate_user! # Example of authentication, adjust as per your setup
  
  def index
    @flows = Flow.all
  end

  def new
    @flow = Flow.new
  end

  def create
    @flow = Flow.new(flow_params)
    if @flow.save
      redirect_to flow_path(@flow), notice: 'Flow was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Add authorization logic here if needed
  end

  def show
  end

  def update
    if @flow.update(flow_params)
      redirect_to flow_path(@flow), notice: 'Flow was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @flow.destroy
    redirect_to flows_path, notice: 'Flow was successfully destroyed.'
  end

  private

  def flow_params
    params.require(:flow).permit(:user_assigned_id, :assigned_user_id, :flow_levels)
  end
end
