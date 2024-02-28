class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role.role_name == "super_admin"
      can :manage, :all
      cannot [:destroy, :update], User, role: { role_name: "super_admin" }
      can [:update, :destroy], User, id: user.id
   elsif user.role.role_name == "admin"
      can :manage, BusinessPartner
      can [:read, :update, :destroy], Expense, user: { role: { role_name: ["admin", "user"] } }
      can :create, Expense
      can :read, User
      can [:update, :destroy], User, role: { role_name: "user" } # Admin can update and destroy normal users
      can [:update, :destroy], User, id: user.id # Admin can update and destroy itself
    elsif user.role.role_name == "user"
      can :read, Expense, user_id: user.id
      can :read, User
      can [:create, :update, :destroy], Expense, user_id: user.id
      can [:update, :destroy], User, id: user.id
      cannot [:destroy, :update], user: { role: { role_name: ["super_admin", "admin"] } }
    else
      can :read, [User, Expense, BusinessPartner]
    end
  end
end
