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

class ActionTest < Test::Unit::TestCase

  @@dir = File.dirname(__FILE__)

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @repo = EA::Repository.open(@@dir+'/eatest.eap')
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    @repo.close
  end

  def test_call_operation_action
    guid="{A1276A55-1433-4def-9238-0153F7917BCE}"
    action=@repo.get_element(guid)
    assert action.is_a?(EA::Action), "Expected element to be an Action"
    assert action.name=="getThis", "Unexpected action name '#{action.name}'"
    assert action.is_call_operation?, "Expected this action to be a call operation! Got false"

    m = action.get_method
    assert m.is_a?(EA::Method), "Expect the method to be of type Method...got false"
    assert m.name=='getThis', "Unexpected method name '#{m.name}'"
    assert m.stereotype=='request/reply', "Unexpected method stereotype '#{m.name}'"

    iface=m.parent
    assert iface.is_a?(EA::Interface), "Expected type Interface"
    assert iface.name=='Interface2', "Unexpected interface name...got '#{iface.name}'"
  end

  def test_ordinary_action
    guid="{6CDB11D7-0AB9-4ac8-98B7-6A811144FF09}"
    action=@repo.get_element(guid)
    assert action.name=="Get a That", "Unexpected action name '#{action.name}'"
    assert_false action.is_call_operation?, "Expected this action to be a call operation! Got false"

    m = action.get_method
    assert_nil m, "Expected the method to be nil...got false"
  end

end