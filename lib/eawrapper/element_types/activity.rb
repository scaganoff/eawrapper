# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for Activity Element
  module Activity

    def get_actions
      actions=[]
      each_partition do |p|
        actions += p.get_actions
      end
      actions
    end

    def each_partition
      each_subelement do |e|
        yield(e) if e.type=='ActivityPartition'
      end
    end
      
  end
end
