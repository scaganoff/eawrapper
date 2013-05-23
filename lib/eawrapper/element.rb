# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
#
require 'eawrapper/element_types/use_case'
require 'eawrapper/element_types/action'
require 'eawrapper/element_types/activity'
require 'eawrapper/element_types/activity_partition'
require 'eawrapper/element_types/actor'
require 'eawrapper/element_types/artifact'
require 'eawrapper/element_types/boundary'
require 'eawrapper/element_types/requirement'
require 'eawrapper/element_types/component'
require 'eawrapper/element_types/decision'
require 'eawrapper/element_types/event'
require 'eawrapper/element_types/expansion_region'
require 'eawrapper/element_types/goal'
require 'eawrapper/element_types/interaction'
require 'eawrapper/element_types/interaction_fragment'
require 'eawrapper/element_types/interaction_occurrence'
require 'eawrapper/element_types/interface'
require 'eawrapper/element_types/interruptible_activity_region'
require 'eawrapper/element_types/issue'
require 'eawrapper/element_types/klass'
require 'eawrapper/element_types/node'
require 'eawrapper/element_types/note'
require 'eawrapper/element_types/object'
require 'eawrapper/element_types/port'
require 'eawrapper/element_types/provided_interface'
require 'eawrapper/element_types/required_interface'
require 'eawrapper/element_types/state_node'
require 'eawrapper/element_types/synchronization'
require 'eawrapper/element_types/text'
require 'eawrapper/element_types/uml_diagram'
require 'eawrapper/mixins/tree_nav'

module EA

  class Element < OLEDelegate
    include TreeNav

    # ToDo: make element a container and rationalize how collections are init'ed for elements & packages

    attr_reader :package, :connectors, :embedded_elements, :methods
    def initialize(kernel,repo,type=nil)
      super(kernel,repo)
      @package=@repo.get_package(@kernel.PackageID)
      @connectors=Collection.new(@kernel.Connectors, @repo, Connector)
      @embedded_elements=Collection.new(@kernel.EmbeddedElements, @repo, Element)
      @methods=Collection.new(@kernel.Methods, @repo, Method)
      @attributes=Collection.new(@kernel.Attributes, @repo, Attribute)
      @name=self.name
      @type=self.type

      # extend this instance with the appropriate Mixin for this Element type
      begin
        elm_type=@kernel.Type
        elm_type='Klass' if elm_type=='Class'
        eml_type='UMLDiagram' if elm_type=='UML Diagram'
        reqd_module=eval "#{elm_type}"
        extend reqd_module
      rescue Exception => err
        $stderr.puts "Error calling mixin for Element type '#{@kernel.Type}' ElementID=#{@kernel.ElementID}"
        $stderr.puts err.message
      end
    end

    def path
      @package.path+'/'+name
    end

    def type
      @kernel.Type
    end

    def element_id
      @kernel.ElementID
    end

    def element_GUID
      @kernel.ElementGUID
    end
    def delete
      idx=@package.elements.find(self)
      @package.elements.delete_at(idx)
    end

    def ==(other)
      return false unless other.is_a? Element
      self.element_id==other.element_id
    end

    def eql?(other)
      return false unless other.is_a? Element
      self.element_id==other.element_id
    end

    def hash
      elementguid.hash
    end

    def status=(status)
      @kernel.Status=status
      @kernel.Update
    end

    def status
      @kernel.Status
    end

    def priority=(priority)
      @kernel.Priority=priority
      @kernel.Update
    end

    def priority
      @kernel.Priority
    end

    def method_missing(sym, *args, &block)
      super(sym, *args, &block)
    end

    def connect_to(supplier_element, name, type)
      con=self.connectors.kernel.AddNew(name,type)
      con.SupplierID=supplier_element.element_id
      con.Update
      self.connectors.kernel.Refresh
      return Connector.new(con, @repo, type)
    end

    def get_subelement_by_name(name)
      each_subelement do |e|
        return @repo.get_element(e.ElementID) if e.Name==name
      end
    end

    def each_subelement
      @kernel.elements.each do |e|
        el=@repo.get_element(e.ElementID)
        yield(el)
      end
    end

    def each_diagram
      @kernel.Diagrams.each do |d|
        diagram=Diagram.new(d, @repo)
        yield(diagram)
      end
    end

    def custom_property(name)
      result=nil
      @kernel.CustomProperties.each do |cp|
        if cp.name==name then
          result=cp.value
          break
        end
      end
      result
    end

    def classifier
      result=nil
      clid=@kernel.ClassifierID
      result=@repo.get_element(clid) unless clid==0
      result
    end

    def add_tagged_value(name, value)
      tv=@kernel.TaggedValues.AddNew(name,'TaggedValue')
      @kernel.TaggedValues.refresh
      unless value.nil?
        tv.value=value
        tv.update
      end
    end

    def get_tagged_value(name)
      @kernel.TaggedValues.GetByName(name)
    end

  end

end