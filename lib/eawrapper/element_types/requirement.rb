# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  module Requirement

    # Returns a list of requirements realized by this Use-Case if the
    # realization arrow has been drawn from the Use-Case to the Requirement.
    def use_cases
      use_cases=[]
      self.connectors.each do |c|
        if c.type=='Realisation' or c.type=='Realization' then
          uc=@repo.get_element(c.clientid)
          use_cases<<uc if uc.type=='UseCase'
        end
      end
      use_cases
    end

    # Returns a list of requirements realized by this Use-Case if the
    # realization arrow has been drawn from the Use-Case to the Requirement.
    def business_processes
      bps=[]
      self.connectors.each do |c|
        if c.type=='Realisation' or c.type=='Realization' then
          bp=@repo.get_element(c.clientid)
          bps<<bp #if bp.stereotype=='BusinessProcess'
        end
      end
      bps
    end

    def components
      components_via_use_case
    end

private

    def components_via_use_case
      components=[]
      use_cases=self.use_cases
      use_cases.each do |uc|
        uc.components.each {|cpt| components << cpt }
      end
      components.uniq
    end
      
  end
end
