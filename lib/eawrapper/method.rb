# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA
  class Method < OLEDelegate

    attr_accessor :parameters
    def initialize(kernel,repo,type=nil)
      super(kernel,repo)
      @parameters=Collection.new(@kernel.Parameters, @repo, Parameter)
    end

    def parent
      @repo.get_element(@kernel.ParentID)
    end

    def return_type=(type)
      @kernel.ReturnType=type
      @kernel.Update
    end

    def return_type
      @kernel.ReturnType
    end

    def add_stereotype(st)
      list=@kernel.stereotype
      list=list.split(",")
      list<<st
      newlist=list.join(",")
      @kernel.StereoType=newlist
      @kernel.Update
    end

    def stereotypes
      list=@kernel.Stereotype
      list.split(",")
    end

  end
end
