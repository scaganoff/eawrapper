# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for ActivityPartition Element
  module ActivityPartition

    def get_actions
      actions=[]
      each_subelement do |e|
          actions << e if e.type=='Action'
      end
      actions
    end

  end
end
