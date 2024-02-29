class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new
    if user.role.role_name == "super_admin"
      can :manage, :all
      cannot [:destroy, :update], User, role: { role_name: "super_admin" }
      can [:update], User, id: user.id
    elsif user.role.role_name == "admin"
      can :manage, BusinessPartner
      can [:read, :update, :destroy], Expense, user: { role: { role_name: ["admin", "user"] } }
      can :create, Expense
      can :create, User
      can :read, User
      can [:update, :destroy], User, role: { role_name: "user" } 
      can [:update], User, id: user.id
      can [:approve, :cancel], Expense 
    elsif user.role.role_name == "user"
      can :read, [User]
      can :read, [Expense], user_id: user.id
      can [:update], User, id: user.id 
      can [:create, :update, :destroy], Expense, user_id: user.id # User can manage its own expenses
      cannot :manage, BusinessPartner
      cannot [:update, :destroy, :read], Expense, user_id: [User.where(role: Role.where(role_name: ["admin", "super_admin"])).pluck(:id)]
    else
      can :read, [User, Expense, BusinessPartner]
    end
  end
end