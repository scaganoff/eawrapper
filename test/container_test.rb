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

module EA
  class ContainerTest < Test::Unit::TestCase

    @@dir = File.dirname(__FILE__)

    def setup
      @repo = Repository.open(@@dir+'/eatest.eap')
    end

    def teardown
      @repo.close
    end

    def test_package_container
      puts ">>> Start test_package_container at #{Time.new}"
      assert @repo.models.size==1
      m = @repo.models[0]
      assert m.is_a? Model
      assert m.name=='Model'

      assert m.packages.size==7, "Expected 7 packages, got #{m.packages.size}"

      p=m.packages[0]
      assert p.is_a? Package
      assert p.name=='Requirements Model', "unexpected Package name is #{p.name}"
      puts ">>> End test_package_container at #{Time.new}"
    end

    def test_package_navigation
      puts ">>> Start test_package_navigation at #{Time.new}"
      p=@repo.models[0].packages[1]
      assert p.name=='Use Case Model', "unexpected Package name is #{p.name}"
      p=p.packages.first
      assert p.name=='Primary Use Cases', "unexpected Package name is #{p.name}"
      p=p.packages[1]
      assert p.name=='Domain2', "unexpected Package name is #{p.name}"
      puts ">>> End test_package_navigation at #{Time.new}"
    end

    def test_element_access
      puts ">>> Start test_element_access at #{Time.new}"
      p=@repo.models.first.packages[1].packages.last.packages.first
      assert p.name=='Domain1', "unexpected Package name is #{p.name}"

      assert p.elements.size==3
      a=[]
      p.elements.each {|e| assert e.is_a? Element; a<<e }
      assert a[0].name=='Actor1', "unexpected element name is #{a[0].name}"
      assert a[0].type=='Actor'
      assert a[1].name=='Use Case1', "unexpected element name is #{a[1].name}"
      assert a[1].type=='UseCase', "unexpected element type is #{a[1].type}"
      assert a[2].name=='Use Case2', "unexpected element name is #{a[2].name}"
      assert a[2].type=='UseCase', "unexpected element type is #{a[2].type}"
      puts ">>> End test_element_access at #{Time.new}"
    end

    def test_find
      puts ">>> Start test_find at #{Time.new}"
      p=@repo.models.first.packages[1].packages.last
      target=p.packages[1]
      idx=p.packages.find(target)
      assert idx==1

      false_target=@repo.models.first.packages.first
      idx=p.packages.find(false_target)
      assert_nil idx
      puts ">>> End test_find at #{Time.new}"
    end

    def test_add_package
      puts ">>> Start test_add_package #{Time.new}"
      p=@repo.models.first.packages[1].packages.last
      assert p.name=='Primary Use Cases', "unexpected Package name is #{p.name}"
      n=p.packages.size
      child=p.add_package('Domain3')
      assert child.name=='Domain3', "unexpected Package name is #{child.name}"
      assert child.is_a? Package
      assert p.packages.size==n+1, "unexpected number of packages: got #{p.packages.size}, expected #{n+1}"

      child.delete
      #assert p.packages.size==n, "unexpected number of packages: got #{p.packages.size}, expected #{n}"
      #assert p.packages.last.name=='Domain2'
      puts ">>> End test_add_package #{Time.new}"
    end

    def test_add_requirement
      puts ">>> Start test_add_requirement #{Time.new}"
      p=@repo.models.first.packages[0]
      assert p.name=='Requirements Model', "unexpected Package name is #{p.name}"

      # Add a new child package
      portal_reqts=p.add_package('Portal Requirements')
      
      reqt=portal_reqts.add_element('Requirement 1',Requirement)
      reqt.notes="This is requirement number 1"
      assert reqt.is_a? Element
      assert reqt.type=="Requirement", "unexpected element type is #{reqt.type}"
      assert reqt.notes=="This is requirement number 1"
      assert portal_reqts.elements.size==1

      reqt.delete
      portal_reqts.elements.refresh
      assert portal_reqts.elements.size==0
      portal_reqts.delete
      p.packages.refresh
      assert p.packages.size==1
      puts ">>> End test_add_requirement #{Time.new}"
    end

  end
end
