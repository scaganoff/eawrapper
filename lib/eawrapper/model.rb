# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA
  class Model < OLEDelegate
    include EA::Container
    
    def initialize(kernel, repo)
      super(kernel, repo)
      init_collections
    end

    def method_missing(sym, *args, &block)
      super(sym, *args, &block)
    end
    
  end
end
