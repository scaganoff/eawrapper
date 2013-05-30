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

  def add_diagram
    p=@repo.get_package_by_name("/Model/Process Model/Workflows")
    d=p.Diagrams.Add("TestDiagram1")
    d.Refresh
    d.DiagramObjects.Add("P1","ActivityPartition")
    d.DiagramObjects.Refresh
  end

end