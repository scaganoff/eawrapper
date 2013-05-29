# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'eawrapper'

class InterfacesTest < Test::Unit::TestCase

  @@dir = File.dirname(__FILE__)

  def setup
    @repo = EA::Repository.open(@@dir+'/eatest.eap')
  end

  def teardown
    @repo.close
  end

  def test_ports
    c=@repo.get_element('Model/Component Model/Domain 1 Components/Component1')
    ports=c.ports
    assert ports.size==2, "Unexpected number of ports - got #{ports.size}"
    p=ports[0]
    assert p.is_a?(EA::Port), "p doesn't seem to be of type EA::Port"
    assert p.name=='ServicePoint'
    assert p.type=='Port'
    assert p.stereotype=='servicePoint'

    c=@repo.get_element('Model/Component Model/Domain 1 Components/Component2')
    ports=c.ports
    assert ports.size==2
    names = ports.map {|p| p.name}
    assert names.include? 'ServicePoint'
    assert names.include? 'RequestPoint'
  end

  def test_interface_usage
    c=@repo.get_element('Model/Component Model/Domain 1 Components/Component2')
    ifaces=c.interfaces
    assert ifaces.size==2
    pifaces=c.provided_interfaces
    assert pifaces.size==1, "Expected 1 provided interface...got #{pifaces.size}"

    piface0 = pifaces[0]
    assert piface0.is_a?(EA::ProvidedInterface), "piface0 is not of type 'EA::ProvidedInterface'"
    assert piface0.name=='Interface2', "Expected 'Interface2'...got #{piface0.name}"
    rifaces=c.required_interfaces
    assert rifaces.size==1, "Expected 1 required interface...got #{rifaces.size}"
    assert rifaces[0].name=='Interface1', "Expected 'Interface1'...got #{rifaces[0].name}"
    riface0 = rifaces[0]
    assert riface0.is_a?(EA::RequiredInterface), "riface0 is not of type 'EA::RequiredInterface'"
  end

  def test_provided_interfaces
    c=@repo.get_element('Model/Component Model/Domain 1 Components/Component2')
    piface=c.provided_interfaces[0]
    actual_iface=piface.interface
    assert actual_iface.is_a?(EA::Interface), "Expected actual_iface to be of type 'EA::Interface'"
    assert actual_iface.name=='Interface2'
    assert actual_iface.type=='Interface'
    assert actual_iface.stereotype='serviceInterface'

    assert actual_iface.methods.count==3
    m=actual_iface.methods[0]
    assert m.is_a?(EA::Method), "Expected m to be of type 'EA::Method'"
    assert m.name=='getThis'
    assert m.returntype=='This'
    assert m.stereotype=='request/reply'
    assert m.parameters.count==1
    p=m.parameters[0]
    assert p.is_a?(EA::Parameter), "Expected p to be of type 'EA::Parameter'"
    assert p.name='aThat'
    assert p.type=='That'

    pc=p.classifier
    assert pc.name=='That'
    assert pc.package.name=='Messages'
  end

  def test_required_interfaces
    c=@repo.get_element('Model/Component Model/Domain 1 Components/Component2')
    riface=c.required_interfaces[0]
    actual_iface=riface.interface
    assert actual_iface.is_a?(EA::Interface), "Expected actual_iface to be of type 'EA::Interface'"
    assert actual_iface.name=='Interface1'
    assert actual_iface.type=='Interface'
    assert actual_iface.stereotype='serviceInterface'

    assert actual_iface.methods.count==3

    m=actual_iface.get_method('getFoo')
    assert m.is_a?(EA::Method), "Expected m to be of type 'EA::Method'"
    assert_not_nil m, "Error finding method 'getFoo' on 'Interface1'"
    assert m.name=='getFoo'
    assert m.returntype=='Foo'
    assert m.stereotype=='request/reply'
    assert m.parameters.count==1

    p=m.parameters[0]
    assert p.is_a?(EA::Parameter), "p is not of type 'EA::Parameter'"
    assert p.name='aBar'
    assert p.type=='Bar'
    pc=p.classifier
    unless pc.is_a? String then
      assert pc.name=='Bar'
      assert pc.package.name=='Messages'
    end

  end

  def test_user_interfaces
    c=@repo.get_element('Model/Component Model/Domain 1 Components/Component2')
    uis=c.user_interfaces
    assert uis.size==1
    ui=uis[0]
    assert ui.name=='UserInterface1'
    assert ui.stereotype=='userInterface'
    assert ui.methods.count==7
  end

   def test_interfaces_component3
    c=@repo.get_element('Model/Component Model/Domain 2 Components/Component3')
    assert c.provided_interfaces.count==0, "Expected no provided interfaces for Component3"
    assert c.required_interfaces.count==1, "Expected one required interface for Component3"
    assert c.required_interfaces[0].name=="Interface1"
    assert c.user_interfaces.count==0, "Expected no user interfaces for Component3"
  end

end
