class User < ApplicationRecord
  has_one_attached :avatar
  belongs_to :company
  belongs_to :role
  has_many :expenses, dependent: :destroy
  
  before_validation :generate_unique_code, on: :create
  validates :user_code, uniqueness: true
  validates_presence_of :role, if: :new_record?
  validate :blank_space
  after_create :set_default_role
  
  attr_accessor :company_code
  attr_accessor :company_name
  validates :email, presence: true
  validates :password, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true

  def super_admin?
    role.role_name == 'super_admin'
  end
  
  def admin?
    role.role_name == 'admin'
  end
  
  def user?
    role.role_name == 'user'
  end

  def approver?
    Flow.exists?(assigned_user_id: id)
  end
  
  private 

  def blank_space
    errors.add(:password, "can't contain spaces") if password&.include?(' ')
  end

  def generate_unique_code
    loop do
      self.user_code = SecureRandom.hex(6) 
      break unless self.class.exists?(user_code: user_code)
    end
  end

  def set_default_role
    self.role ||= Role.find_by(role_name: 'super_admin')
  end

  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable, :confirmable
end
