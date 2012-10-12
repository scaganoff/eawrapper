# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  module Component

    def use_cases
      result=[]
      @kernel.Connectors.each do |c|
        [:clientID, :supplierID].each do |endpt|
          e=@repo.get_element(c.send(endpt))
          result << e if e.is_a? UseCase
        end
      end
      result
    end
    
    def user_interfaces
      result=[]
      @kernel.Connectors.each do |c|
        [:clientID, :supplierID].each do |endpt|
          e=@repo.get_element(c.send(endpt))
          result << e if (e.is_a? Class and e.stereotype=='userInterface')
        end
      end
      result
    end

    def ports
      ports=self.embedded_elements.find_all {|e| e.type=='Port'}
      ports.map {|p| Element.new(p,@repo)}
    end
    
    def interfaces(match=/Interface/)
      result=[]
      ports.each do |p|
        matches = p.embedded_elements.find_all {|e| e.type=~match}
        result += matches
      end
      result
    end
    
    def provided_interfaces
      interfaces(/ProvidedInterface/)
    end

    def required_interfaces
      interfaces(/RequiredInterface/)
    end

  end

end

