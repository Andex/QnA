class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      @user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
    can :email, User
    can :set_email, User
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :destroy, Reward, question: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }

    can :best, Answer, question: { user_id: user.id }

    alias_action :vote_up, :vote_down, to: :vote
    can :vote, [Question, Answer] do |votable|
      !user.is_author?(votable)
    end

    can :cancel_vote, [Question, Answer] do |votable|
      user.voted?(votable)
    end
  end
end
