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

class ActivityDiagramTest < Test::Unit::TestCase

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

  def test_get_activity
    bp=@repo.get_element('/Model/Process Model/Workflows/BusinessProcess1')
    activity=bp.get_subelement_by_name('Activity 1')
    assert activity.Name=="Activity 1", "Unexpected activity name '#{activity.Name}'"
    assert activity.is_a?(EA::Activity), "Unexpected activity type"
  end

  def test_get_actions
    bp=@repo.get_element('/Model/Process Model/Workflows/BusinessProcess1')
    activity=bp.get_subelement_by_name('Activity 1')
    actions=activity.get_actions()
    assert actions.count==7, "Unexpected number of actions: #{actions.count}"

    getFoo=actions[3]
    assert getFoo.name=='getFoo', "Unexpected Action name '#{getFoo.name}'"
    cpt=getFoo.component
    assert cpt.name=='Component1', "Unexpected parent component '#{cpt.name}'"
  end

  def test_request_reply_consumer
    guid="{A1276A55-1433-4def-9238-0153F7917BCE}"
    action=@repo.get_element(guid)
    assert action.is_a?(EA::Action), "Expected element to be an Action"
    assert action.name=="getThis", "Unexpected action name '#{action.name}'"
    assert action.is_call_operation?, "Expected this action to be a call operation! Got false"

    c=action.get_consumer
    assert c.is_a?(EA::Action)
    assert c.name=='getFoo'
  end

  def test_one_way_out_consumer
    guid="{FB3ABD0A-1D15-498b-A710-806F032B716F}"
    action=@repo.get_element(guid)
    assert action.is_a?(EA::Action), "Expected element to be an Action"
    assert action.name=="notifyBaz", "Unexpected action name '#{action.name}'"
    assert action.is_call_operation?, "Expected this action to be a call operation! Got false"

    c=action.get_consumer
    assert c.is_a?(EA::Action)
    assert c.name=='Wait for Baz'
  end

  def test_activity_partition
    guid="{FB3ABD0A-1D15-498b-A710-806F032B716F}"
    action=@repo.get_element(guid)
    assert action.is_a?(EA::Action), "Expected element to be an Action"
    assert action.name=="notifyBaz", "Unexpected action name '#{action.name}'"

    pc=action.partition_classifier
    assert pc.name=='Component1'
    assert pc.is_a?(EA::Component)
  end

  def test_find_in_diagrams
    result=@repo.find_in_diagrams(275)
    assert result.count==2
    result.each do |r|
      assert r.is_a?(EA::Diagram),"Expected diagram...got '#{r.type}'"
    end
    names=result.map {|r| r.name}
    assert names.include? "Activity2"
    assert names.include? "Activity3"
  end

end