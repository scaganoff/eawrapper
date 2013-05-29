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

class ClassesTest < Test::Unit::TestCase

  @@dir = File.dirname(__FILE__)

  def setup
    @repo = EA::Repository.open(@@dir+'/eatest.eap')
    i = @repo.get_element("/Model/Domain Model/Messages/IFoo")
    i.delete unless i.nil?
  end

  def teardown
    @repo.close
  end

  def test_create_interface_with_methods

    p = @repo.get_package("/Model/Domain Model/Messages")
    interface = p.add_element("IFoo",EA::Interface)
    m=interface.methods.add_new("do_foo")
    m.parameters.add_new("p1","string")
    m.return_type="Bar"
    #m.add_stereotype("request/reply")  # TODO: multiple stereotypes don't work yet.'
    m.add_stereotype("one-way-out")

    i2 = @repo.get_element("/Model/Domain Model/Messages/IFoo")
    assert_equal(i2.name,"IFoo", "Unexpected name")
    assert(i2.type=="Interface","Unexpected element type #{i2.type}")
    assert_equal(i2.methods.count,1, "Unexpected number of methods.")

    m2=i2.methods.first
    assert_equal(m2.name,"do_foo","Unexpected method name")
    assert_equal(m2.return_type,"Bar","Unexpected return type")
    assert(m2.stereotypes==["one-way-out"],"Unexpected stereotypes: #{m2.stereotypes}")
    p2=m2.parameters.first
    assert_equal(p2.name,"p1","Unexpected parameter name")

    i2.delete
  end

  def test_create_class_with_methods

    p = @repo.get_package("/Model/Domain Model/Messages")
    klass = p.add_element("FooImpl",EA::Klass)
    m=klass.methods.add_new("do_foo")
    m.parameters.add_new("p1","string")
    m.return_type="Bar"
    m.add_stereotype("request/reply")

    k2 = @repo.get_element("/Model/Domain Model/Messages/FooImpl")
    assert_equal(k2.name,"FooImpl", "Unexpected name")
    assert(k2.type=="Class","Unexpected type #{k2.type} ")
    assert_equal(k2.methods.count,1, "Unexpected number of methods.")

    m2=k2.methods.first
    assert_equal(m2.name,"do_foo","Unexpected method name")
    assert_equal(m2.return_type,"Bar","Unexpected return type")
    assert(m2.stereotypes==["request/reply"])
    p2=m2.parameters.first
    assert_equal(p2.name,"p1","Unexpected parameter name")

    k2.delete
  end


end