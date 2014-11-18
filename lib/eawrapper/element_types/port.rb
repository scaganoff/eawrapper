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
