# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 
#
require 'eawrapper/diagram_types/activity'
require 'eawrapper/diagram_types/analysis'
require 'eawrapper/diagram_types/custom'
require 'eawrapper/diagram_types/sequence' # TODO: are diagram_types actually needed????
require 'eawrapper/diagram_types/use_case'
require 'eawrapper/mixins/tree_nav'

module EA

  class Diagram < OLEDelegate
    include TreeNav

    def initialize(kernel, repo, type=nil)
      super(kernel, repo)

      @name=self.name
      @type=self.type

      # extend this instance with the appropriate Mixin for this Diagram type
      begin
        diag_type=@kernel.Type
        reqd_module=eval "#{diag_type}"
        extend reqd_module
      rescue Exception => err
        $stderr.puts "Error calling mixin for Diagram type '#{@kernel.Type}' DiagramID=#{@kernel.DiagramID}"
        $stderr.puts err.message
      end
    end

    def diagram_id
      @kernel.DiagramID
    end

    def elements
      result=[]
      each_element {|e| result << e }
      result
    end

    def each_element
      @kernel.DiagramObjects.each do |obj|
        element=@repo.get_element(obj.ElementID)
        # TODO: Can we add left,right,top,bottom properties to the Element as instance variables?
        yield(element)
      end
    end

    def connectors
      result=[]
      each_connector {|c| result << c}
      result
    end

    def each_connector
      @kernel.DiagramLinks.each do |dl|
        c=@repo.get_connector(dl.ConnectorID)
        yield(c)
      end
    end

  end

end