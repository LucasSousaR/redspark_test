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
          can :manage, Card
          can :manage, Category
          can :manage, Statement
          can :manage, Attachment
          can :manage, ContabilPattern

          #can :manage, User, role: { code: ['operational'] }, company_users: { company_id: user.company_ids }
          can :index, Role, code: ['operational']
          can :index, User, code: ['operational']
          can :index, Card
          can :index, Category
          can :index, Statement
          can :index, Attachment
          can :search_companies, Company

          #can :index, Notification
          #can :manage, Version




        elsif user.role.code == 'operational'

          can :read, :dashboards

          can :index, Card, user_id: user.id
          can :index, Category, company_id: user.company_ids

          can :manage, Statement, user_id: user.id
          can :manage, Attachment, statement_id: user.statement_ids

          cannot :index, Company, id: user.company_ids
          cannot :manage, [Company,  User, Role, ]

          can [:graphics, :graphic_resellers], :dashboard



        end
      end
    end
  end
end