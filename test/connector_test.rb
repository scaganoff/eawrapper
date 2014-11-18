#
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2014, Saul Caganoff
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
  end

  def teardown
    @repo.close
  end

  def test_create_class_dependency
	 @this = @repo.get_element("/Model/Domain Model/Messages/This")
	 @that = @repo.get_element("/Model/Domain Model/Messages/That")
	 c = @this.connect_to(@that, "D1", "Dependency")
	 assert_equal(c.name,"D1")
	 assert_equal(@this.connectors.count,1)
	 assert_equal(@this.connectors.first.name,"D1")
	 assert_equal(c.source.element_id,@this.element_id)
	 assert_equal(c.target.element_id,@that.element_id)
	 puts "---dump1---"
	 @this.connectors.each {|z| puts ">> #{z.name}"}
	 puts "---end dump---"
	 c.delete
	 #assert_equal(@this.connectors.count,0)
	 puts "---dump2---"
	 @this.connectors.each {|z| puts ">> #{z.name}"}
	 puts "---end dump---"
  end

  def test_create_component_dependency
	 cpt1 = @repo.get_element("/Model/Component Model/Domain 1 Components/Component1")
	 cpt2 = @repo.get_element("/Model/Component Model/Domain 1 Components/Component2")
	 baseline_count = cpt1.connectors.count

	 c = cpt1.connect_to(cpt2, "D2", "Dependency")
	 assert_equal("D2",c.name)
	 assert_equal(baseline_count+1, cpt1.connectors.count)
	 assert_equal("D2",cpt1.connectors[baseline_count].name) # Assumes new connector is appended
	 assert_equal(c.source.element_id,cpt1.element_id)
	 assert_equal(c.target.element_id,cpt2.element_id)
	 puts "---dump3---"
	 cpt1.connectors.each {|z| puts ">> #{z.name}"}
	 puts "---end dump---"
	 c.delete
	 #assert_equal(baseline_count, cpt1.connectors.count)
	 puts "---dump4---"
	 cpt1.connectors.each {|z| puts ">> #{z.name}"}
	 puts "---end dump---"
  end

  def test_create_information_flow
	 cpt1 = @repo.get_element("/Model/Component Model/Domain 1 Components/Component1")
	 cpt2 = @repo.get_element("/Model/Component Model/Domain 1 Components/Component2")
	 baseline_count = cpt1.connectors.count

	 c = cpt1.connect_to(cpt2, "IF1", "InformationFlow")
	 assert_equal("IF1",c.name)
	 assert_equal(baseline_count+1, cpt1.connectors.count)
	 assert_equal("IF1",cpt1.connectors[baseline_count].name) # Assumes new connector is appended
	 assert_equal(c.source.element_id,cpt1.element_id)
	 assert_equal(c.target.element_id,cpt2.element_id)
	 puts "---dump5---"
	 cpt1.connectors.each {|z| puts ">> #{z.name}"}
	 puts "---end dump---"

	# Test Conveyed Items
	 this = @repo.get_element("/Model/Domain Model/Messages/This")
	 c.add_conveyed_item(this)
	 assert_equal(1, c.conveyed_items.count)
	 assert_equal("This",c.conveyed_items.first.name)
	 puts "---dump6---"
	 c.conveyed_items.each {|i| puts "conveyed item: #{i.name}"}
	 puts "---end dump---"


	 c.delete
	 #assert_equal(baseline_count, cpt1.connectors.count)
	 puts "---dump7---"
	 cpt1.connectors.each {|z| puts ">> #{z.name}"}
	 puts "---end dump---"
  end

end
