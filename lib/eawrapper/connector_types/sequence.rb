# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 
#

module EA

  module Sequence

    def kind
      @kernel.properties('Name').value
    end

    def provider
      result=nil
      raise "Unknown MEP for sequence '#{name}'" if mep=='unknown'
      result=source_endpoint if mep=='one-way-out'
      result=target_endpoint if mep=='one-way-in'
      result=target_endpoint if mep=='request/reply'
      result.endpoint_type=:provider
      result
    end

    def consumer
      result=nil
      raise "Unknown MEP for sequence '#{name}'" if self.mep=='unknown'
      begin
        result=target_endpoint if mep=='one-way-out'
        result=source_endpoint if mep=='one-way-in'
        result=source_endpoint if mep=='request/reply'
        result.endpoint_type=:consumer
      rescue Exception=>e
        $stderr.puts "Error creating consumer"
        $stderr.puts e.message
      end
      result
    end

    def mep
      result='unknown'
      target_mep=target_endpoint.mep
      source_mep=source_endpoint.mep
      result = source_mep if source_mep=='one-way-out'
      result = target_mep if target_mep=='one-way-in'
      result = target_mep if target_mep=='request/reply'
      result
    end

    def target_endpoint
      @target_endpoint ||= EA::Services::Endpoint.new(target, :target, name)
    end

    def source_endpoint
      @source_endpoint ||= EA::Services::Endpoint.new(source, :source, name)
    end

    def to_s
      c = self.consumer
      p = self.provider
      arrow = "<->" if p.mep=='request/reply'
      arrow = "-->" if p.mep=='one-way-in'
      arrow = '<--' if p.mep=='one-way-out'
      return "#{c.to_s}\t#{arrow}\t#{p.to_s}"
    end

  end

end