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

class DatabaseQueriesTest < Test::Unit::TestCase

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