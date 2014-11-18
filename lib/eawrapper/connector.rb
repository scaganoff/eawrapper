# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
#
require 'eawrapper/connector_types/association'
require 'eawrapper/connector_types/control_flow'
require 'eawrapper/connector_types/information_flow'
require 'eawrapper/connector_types/dependency'
require 'eawrapper/connector_types/note_link'
require 'eawrapper/connector_types/object_flow'
require 'eawrapper/connector_types/realisation'
require 'eawrapper/connector_types/sequence'

module EA

  class Connector < OLEDelegate

    attr_reader :package, :source, :target, :conveyed_items
    def initialize(kernel,repo,type=nil)
      super(kernel,repo)
      @source=@repo.get_element(@kernel.ClientID)
      @target=@repo.get_element(@kernel.SupplierID)
      @conveyed_items=Collection.new(@kernel.ConveyedItems, @repo, Element) # TODO: move this into the mixin

      # extend this instance with the appropriate Mixin for this Connector type
      begin
        connector_type=@kernel.Type
        reqd_module=eval "#{connector_type}"
        extend reqd_module
      rescue Exception => err
        $stderr.puts "Error calling mixin for Connector type '#{@kernel.Type}' ConnectorID=#{@kernel.ConnectorID}"
        $stderr.puts err.message
      end
    end

    def method_missing(sym, *args, &block)
      super(sym, *args, &block)
    end

    def type
      @kernel.Type
    end

    def type=(new_type)
      @kernel.Type=new_type
      @kernel.Update
    end

    def connector_id
      @kernel.ConnectorID
    end

    def delete
      source_idx=@source.connectors.find(self)
      @source.connectors.delete_at(source_idx)
		@source.update
    end

    def ==(other)
      return false unless other.is_a? Connector
      self.connector_id==other.connector_id
    end

  end

end
