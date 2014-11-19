# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for ProvidedInterface Element
  module ProvidedInterface
    
    # Return the interface referred to by this provider element.
    def interface
      @repo.get_element(@kernel.ClassifierID)
    end

    def port
      @repo.get_element(@kernel.ParentID)
    end

    def component
      self.port.component
    end

	 def add_assembly(target,name="")
		ass = self.connect_to(target, name, "Assembly")
		return ass
	 end

  end

end
