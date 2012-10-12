# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for Event Element
  module Event

    def search_classifier
      rs=@repo.search(@name, 'Method Details')
      klass=rs[0] if rs.count==1
    end

    def component
      parent=@repo.get_element(@kernel.ParentID)
      @repo.get_element(parent.ClassifierID)
    end

    def is_call_operation?
      self.custom_property('kind')=='CallOperation'
    end

    def partition_classifier
      p=self.parent
      p.classifier unless p.nil?
    end

private

  end
end
