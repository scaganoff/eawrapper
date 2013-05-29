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

class TraceabilityTest < Test::Unit::TestCase

  @@dir = File.dirname(__FILE__)

  def setup
    @repo = EA::Repository.open(@@dir+'/eatest.eap')
  end

  def teardown
    @repo.close
  end

  def test_trace_usecases
    rqt=@repo.get_element('Model/Requirements Model/Functional/Reqt2')
    use_cases = rqt.use_cases
    assert use_cases.count==3
    uc_names=[]
    use_cases.each {|uc| uc_names<<uc.name }
    assert uc_names.include?('Use Case2')
    assert uc_names.include?('Use Case3')
    assert uc_names.include?('Use Case4')
  end

  def test_trace_rqts
    uc=@repo.get_element('Model/Use Case Model/Primary Use Cases/Domain2/Use Case4')
    rqts=uc.requirements
    assert rqts.count==2
    rqts_names=[]; rqts.each {|r| rqts_names<<r.name }
    assert rqts_names.include? 'Reqt2'
    assert rqts_names.include? 'Reqt3'
  end

  def test_uc_components
    uc=@repo.get_element('Model/Use Case Model/Primary Use Cases/Domain2/Use Case4')
    cpts=uc.components
    assert cpts.count==2
    cpt_names=[]; cpts.each {|c| cpt_names<<c.name }
    assert cpt_names.include?('Component1')
    assert cpt_names.include?('Component2')
  end

  def test_cpt_use_cases
    cpt=@repo.get_element('Model/Component Model/Domain 1 Components/Component1')
    ucs=cpt.use_cases
    assert ucs.count==4
    uc_names=[]; ucs.each {|uc| uc_names<<uc.name }
    assert uc_names.include?('Use Case1')
    assert uc_names.include?('Use Case2')
    assert uc_names.include?('Use Case3')
    assert uc_names.include?('Use Case4')
  end

  def test_rqt_components
    rqt = @repo.get_element('Model/Requirements Model/Functional/Reqt1')
    cpts = rqt.components
    assert cpts.count==1
    assert cpts[0].name=='Component1'
  end

  def test_rqt_components2
    rqt = @repo.get_element('Model/Requirements Model/Functional/Reqt2')
    cpts = rqt.components
    assert cpts.count==2
    cpt_names=[]; cpts.each {|c| cpt_names<<c.name }
    assert cpt_names.include?('Component1')
    assert cpt_names.include?('Component2')
  end
end
