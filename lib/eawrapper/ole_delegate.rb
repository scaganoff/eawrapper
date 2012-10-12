# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
#

module EA
	
	class OLEDelegate

    #ToDo: Add support for TaggedValues collection

    attr_reader :kernel, :repo
		def initialize(kernel, repo)
			@kernel=kernel
      @repo=repo
		end

    def name
      @kernel.Name
    end

    def notes=(notes)
      @kernel.Notes=notes
      @kernel.Update
    end

    def notes
      @kernel.Notes
    end

    def alias=(txt)
      @kernel.Alias=txt
      @kernel.Update
    end

    def alias
      @kernel.Alias
    end

    def method_missing(sym, *args, &block)
      @kernel.send(sym, *args, &block)
    end

	end
	
end