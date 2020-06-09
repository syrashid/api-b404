class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def update?
    # record < the object you're acting on, user < current user
    record.user == user
  end

  def create?
    !user.nil?
  end

  def destroy?
    update?
  end
end
