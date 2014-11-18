# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA
  class Attribute < OLEDelegate

    attr_accessor :parameters
    def initialize(kernel,repo,type=nil)
      super(kernel,repo)
    end

    def parent
      @repo.get_element(@kernel.ParentID)
    end

  end
end
