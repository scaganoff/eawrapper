# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA
  class Parameter < OLEDelegate
    def initialize(kernel,repo,type=nil)
      super(kernel,repo)
      @name=kernel.name
      @type=self.type
    end

    def type
      @kernel.Type
    end

    def classifier
      begin
        result=@repo.get_element((@kernel.ClassifierID).to_i)
      rescue
        puts "Warning: cannot find classifier for parameter '#{@name}'. Using 'type' instead."
        result=self.type
      end
      result
    end
  end
end
