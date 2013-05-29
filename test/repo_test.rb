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

class RepoTest < Test::Unit::TestCase

  @@dir = File.dirname(__FILE__)

  def setup
    @repo = EA::Repository.open(@@dir+'/eatest.eap')
  end

  def teardown
    @repo.close
  end


  def test_get_requirements
    rqts=@repo.get_elements(EA::Requirement)
    assert rqts.size==3
  end

  def test_get_package
    p=@repo.get_package('Model/Requirements Model/Functional')
    assert p.name=='Functional'

    id=p.package_id
    p=@repo.get_package(id)
    assert p.name=='Functional'

    guid = p.package_GUID
    p=@repo.get_package(guid)
    assert p.name=='Functional'

  end

  def test_get_element
    e=@repo.get_element('Model/Requirements Model/Functional/Reqt1')
    assert e.name=='Reqt1'
    assert e.is_a? EA::Element
    assert e.type=='Requirement'

    guid = e.element_GUID
    e=@repo.get_element(guid)
    assert e.name=='Reqt1'
    assert e.is_a? EA::Element
    assert e.type=='Requirement'

    id=e.element_id
    e=@repo.get_element(id)
    assert e.name=='Reqt1'
    assert e.is_a? EA::Element
    assert e.type=='Requirement'
  end

   def test_get_package_as_element
    e=@repo.get_element(7)  # Package "Domain2" is associated with ElementID=7
    assert e.is_a? EA::Package
    assert e.packageid==8
  end

  # TODO: allow/require leading '/' in get_element path.

  def test_ancestor_test
    bp=@repo.get_element('Model/Process Model/Workflows/BusinessProcess1')
    activity1=bp.get_subelement_by_name('Activity 1')
    assert activity1.has_ancestor_package?('/Model/Process Model')==true
    assert activity1.has_ancestor_package?('/Model/Use Case Model')==false
  end

#  def test_connect
#    repo=EA::Repository.connect
#    assert_not_nil repo
#  end

end
