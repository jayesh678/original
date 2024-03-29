namespace :reports do

  desc "Send daily expenses report to super admin"
  task send_daily_expenses_report: :environment do  
    super_admin_email = User.find_by(role: Role.find_by(role_name: "super_admin")).email
    approved_expenses = Expense.approved_expenses_report

    ExpenseReportMailer.send_daily_expenses_report(super_admin_email, approved_expenses).deliver_now

    puts "Daily expenses report sent to super admin: #{approved_expenses.inspect}"
  end
end
