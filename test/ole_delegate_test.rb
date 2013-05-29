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


class OleDelegateTest < Test::Unit::TestCase

  @@dir = File.dirname(__FILE__)

  def setup
    @repo = EA::Repository.open(@@dir+'/eatest.eap')
  end

  def teardown
    @repo.close
  end

  def test_mm_element
    e=@repo.get_element('Model/Component Model/Domain 1 Components/Component2')
    assert e.complexity=='1'
    assert e.version=='1.0'
    assert e.phase=='1.0'
  end

  def test_mm_model
    m=@repo.models[0]
    assert_not_nil m.packageguid
    assert_not_nil m.created
    assert_not_nil m.owner
  end

  def test_mm_package
    p=@repo.models[0].packages[0]
    assert_not_nil p.packageguid
    assert_not_nil p.created
    assert_not_nil p.owner
  end

  def test_mm_repo
    r=@repo
    assert_not_nil r.getprojectinterface
#    assert_not_nil r.app
    assert_not_nil r.instanceguid
  end
end
