# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for Interface Element
  module Interface

    def get_method(target)
      result=nil
      @kernel.Methods.each do |m|
        if (m.name==target) then
          result=EA::Method.new(m,@repo)
        end
      end
      result
    end

	 def add_assembly(target)
		ass = self.connect_to(target, "Assembly")
		return ass
	 end

  end
end
