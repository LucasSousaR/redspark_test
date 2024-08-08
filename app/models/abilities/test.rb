module Abilities
  class Test
    include CanCan::Ability

    def initialize(user)
      if user.present?
        alias_action :read, :update, :create, to: :modify

        if user.role.code == 'admin'
          can :read, :dashboards
          can :manage, User
          can :manage, Company
          can :manage, Proponent

          can :index, Role, code: ['operational']
          can :index, User, code: ['operational']
          can :search_companies, Company

          #can :index, Notification
          #can :manage, Version




        elsif user.role.code == 'operational'

          can :read, :dashboards
          can [:graphics, :graphic_resellers], :dashboard


          cannot :index, Company, id: user.company_id
          cannot :manage, [Company,  User, Role, ]





        end
      end
    end
  end
end