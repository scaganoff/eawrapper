# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for ExpansionRegion Element
  module ExpansionRegion

    def partition_classifier
      p=self.parent
      p.classifier unless p.nil?
    end

  end
end
