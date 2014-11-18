# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2014, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 
#
module EA

  module InformationFlow

	  def add_conveyed_item(el)
		  self.conveyed_items.kernel.AddNew(el.elementguid,nil)
		  self.conveyed_items.kernel.Refresh
	  end
  end

end
