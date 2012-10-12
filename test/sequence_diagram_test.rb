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

class SequenceDiagramTest < Test::Unit::TestCase

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


  def test_get_diagram
    diagram=@repo.get_diagram_by_name('/Model/Process Model/Orchestrations/Sequence Diagram 1')
    assert diagram.Name=="Sequence Diagram 1"
  end

  def test_get_connectors
    diagram=@repo.get_diagram_by_name('/Model/Process Model/Orchestrations/Sequence Diagram 1')
    connectors=diagram.connectors
    assert connectors.count==3
    assert connectors[0].name=="getFoo(Bar)", "Got connector name '#{connectors[0].name}'"
    assert connectors[1].name=="getBar(Foo)", "Got connector name '#{connectors[0].name}'"
    assert connectors[2].name=="notifyBaz(Baz)", "Got connector name '#{connectors[0].name}'"

    provider_endpoint = connectors[0].provider
    assert provider_endpoint.to_s=='Component1::Interface1::getFoo', "Unexpected result '#{provider_endpoint.to_s}'"
    assert provider_endpoint.mep=='request/reply'
    consumer_endpoint = connectors[0].consumer
    consumer_endpoint.component.name=='Component2'

    provider_endpoint = connectors[2].provider
    assert provider_endpoint.to_s=='Component1::Interface1::notifyBaz', "Unexpected result '#{provider_endpoint.to_s}'"
    assert provider_endpoint.mep=='one-way-out'
    consumer_endpoint = connectors[0].consumer
    consumer_endpoint.component.name=='Component2'
  end

  def test_endpoints
    diagram=@repo.get_diagram_by_name('/Model/Process Model/Orchestrations/Sequence Diagram 1')
    connectors=diagram.connectors

    provider_endpoint = connectors[0].provider
    assert provider_endpoint.to_s=='Component1::Interface1::getFoo', "Unexpected result '#{provider_endpoint.to_s}'"
    assert provider_endpoint.mep=='request/reply'
    consumer_endpoint = connectors[0].consumer
    consumer_endpoint.component.name=='Component2'

    provider_endpoint = connectors[2].provider
    assert provider_endpoint.to_s=='Component1::Interface1::notifyBaz', "Unexpected result '#{provider_endpoint.to_s}'"
    assert provider_endpoint.mep=='one-way-out'
    consumer_endpoint = connectors[0].consumer
    consumer_endpoint.component.name=='Component2'

  end

  def test_sequence_order
    diagram=@repo.get_diagram_by_name('/Model/Process Model/Orchestrations/Sequence Diagram 2')
    connectors=diagram.connectors

    assert connectors.count==4
    (0..3).each do |idx|
#      assert connectors[idx].SequenceNo==idx, "Got #{connectors[idx].SequenceNo}, expected #{idx}"
    end
  end

  def test_list_sequences
    diagram=@repo.get_diagram_by_name('/Model/Process Model/Orchestrations/Sequence Diagram 2')
    connectors=diagram.connectors

    connectors.each do |c|
      begin
        puts c.to_s
      #rescue Exception => e
      #  puts "Error processing connector #{c.name}"
      #  puts e.message
      end
    end

  end

end