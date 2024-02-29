class Expense < ApplicationRecord
  # original
  belongs_to :user
  belongs_to :flow
  belongs_to :business_partner
  belongs_to :category
  has_many :subcategories
  has_one_attached :receipt 
  before_create :generate_application_number
  before_validation :associate_flow, on: :create

  enum status: { ideal: 0, initiated: 1, approved: 2, cancelled: 3 }

  validates :application_number, uniqueness: true
  validates :application_name, presence: true 
  validates :number_of_people, presence: true 
  validates :total_amount, presence: true 
  validates :date_of_application, presence: true
  validates :expense_date, presence: true
  validates :category, presence: true
  validates :business_partner, presence: true
  validates :amount, presence: true
  validates :tax_amount, presence: true
  validates :description, presence: true
  validates :receipt, presence: true
  validates_presence_of :start_date, :end_date, :source, :destination, if: :travel_expense
  validate :end_date_is_after_start_date, if: -> { travel_expense && start_date.present? && end_date.present? }

  def travel_expense
    category_id == Category.find_by(category_type: "Travel")&.id
  end

  private

  def generate_application_number
    category_prefix = category_prefix_for_application_number
    last_application_number = Expense.where(category_id: category_id).maximum(:application_number).to_i
    new_application_number = last_application_number + 1
    loop do
      candidate_application_number = "#{category_prefix}#{new_application_number}"
      unless Expense.exists?(application_number: candidate_application_number)
        self.application_number = candidate_application_number
        break
      end
      new_application_number += 1
    end
  end

  def category_prefix_for_application_number
    category_id == 1 ? 'E-' : 'T-'
  end

  def end_date_is_after_start_date
    errors.add(:end_date, "cannot be before the start date") if end_date < start_date
  end

  def associate_flow
    self.flow ||= Flow.find_or_create_by(user_assigned_id: user_id)
    self.flow.update(assigned_user_id: predefined_approver_id)
  end

  def predefined_approver_id
    approver_email = 'xyz@gmail.com'
    approver = User.find_by(email: approver_email)
    approver.id if approver
  end
  # approver_emails = "a@b.com", 'c@d.com'
  # approvers = User.where(email: approver_emails)
  # approvers.pluck(:ids)


  def self.approved_expenses_report
    approved_expenses = Expense.where(status: :approved)
    approved_expenses
  end
end