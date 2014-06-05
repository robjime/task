class Ability
  include CanCan::Ability

  def initialize(user)
    #can [:create], Event
    can [:create, :index, :show, :update, :destroy], Event do |event|
      event.user == user
    end
  end
end