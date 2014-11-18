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

  def test_create_assembly
	 cpt1 = @repo.get_element("/Model/Component Model/Domain 3 Components/Component4")
	 cpt2 = @repo.get_element("/Model/Component Model/Domain 3 Components/Component5")
	 baseline_count = cpt1.connectors.count

	# add ports and interfaces
	 p1 = cpt1.add_port
	 if1 = p1.add_provided_interface("Interface1")

	 p2 = cpt2.add_port
	 if2 = p2.add_consumed_interface("Interface1")

	 c = if1.add_assembly(if2)

	 assert_equal(1,cpt1.ports.count)
	 assert_equal(1,cpt1.ports.interfaces.count)
	 assert_equal("Interface1",cpt1.ports.interfaces.first.name)
	 assert_equal(1,cpt2.ports.count)
	 assert_equal(1,cpt2.ports.interfaces.count)
	 assert_equal("Interface1",cpt2.ports.interfaces.first.name)

  end

end
