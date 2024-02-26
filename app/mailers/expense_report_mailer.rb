class ExpenseReportMailer < ApplicationMailer
  def send_daily_expenses_report(super_admin_email, approved_expenses)
    @approved_expenses = approved_expenses
    mail(to: super_admin_email, subject: 'Daily Expenses Report')
  end
end
