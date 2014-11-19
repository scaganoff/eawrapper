# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for Port Element
  module Port

    def component
      @repo.get_element(@kernel.ParentID)
    end

	 def delete
		cpt=self.component
		idx=cpt.embedded_elements.find(self)
		cpt.embedded_elements.delete_at(idx)
		cpt.embedded_elements.refresh
		cpt.update
	 end

    def interfaces(match=/Interface/)
      arr = self.embedded_elements.find_all {|e| e.type=~match}
      arr.map {|p| Element.new(p,@repo)}
    end
    
    def provided_interfaces
      interfaces(/ProvidedInterface/)
    end

    def required_interfaces
      interfaces(/RequiredInterface/)
    end

	 def add_provided_interface(name)
		p=self.embedded_elements.add_new(name,"ProvidedInterface")
		return p
	 end
      
	 def add_required_interface(name)
		p=self.embedded_elements.add_new(name,"RequiredInterface")
		return p
	 end
      
  end
  
end
