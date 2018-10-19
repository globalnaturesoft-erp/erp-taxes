Erp::Ability.class_eval do
  def taxes_ability(user)
    
    can :creatable, Erp::Taxes::Tax do |tax|
      if Erp::Core.available?("ortho_k")
        user == Erp::User.get_super_admin or
        user.get_permission(:system, :taxes, :taxes, :create) == 'yes'
      else
        true
      end
    end
    
    can :updatable, Erp::Taxes::Tax do |tax|
      !tax.is_deleted? and
      (
        if Erp::Core.available?("ortho_k")
          user == Erp::User.get_super_admin or
          user.get_permission(:system, :taxes, :taxes, :update) == 'yes'
        else
          true
        end
      )
    end
    
    can :activatable, Erp::Taxes::Tax do |tax|
      false
    end
    
    can :cancelable, Erp::Taxes::Tax do |tax|
      !tax.is_deleted? and
      (
        if Erp::Core.available?("ortho_k")
          user == Erp::User.get_super_admin or
          user.get_permission(:system, :taxes, :taxes, :delete) == 'yes'
        else
          true
        end
      )
    end
    
  end
end
