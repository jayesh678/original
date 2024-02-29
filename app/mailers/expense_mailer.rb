class ExpenseMailer < ApplicationMailer
    
  def notify_assigned_user(flow_id)
    flow = Flow.find_by(user_assigned_id: flow_id)
    if flow.present? 
      @user = User.find_by(id: flow.assigned_user_id)
      if @user.present?
        @expense = Expense.where(flow_id: flow.id).order(created_at: :desc).first
        mail(to: @user.email, subject: 'New Expense Assigned') if @expense.present?
      end
    end
  end


  def notify_super_admin(expense)
    @expense = expense
    @super_admin_email = User.find_by(role: Role.find_by(role_name: 'super_admin')).email
    mail(to: @super_admin_email, subject: 'Expense Approved')
  end
  
end
