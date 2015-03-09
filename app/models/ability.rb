class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

        can :read, :all

        can :manage, Article do |article|
            article && article.user_id == user.id
        end

        can :manage, Album do |album|
        album && album.user_id == user.id  
        end

        can :manage, Comment do |comment|
          comment && comment.commenter_id == user.id
        end

        #admin access
        can :manage, :all if user.is? :admin
  end

end
