# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for Action Element
  module Action

    def search_classifier
      rs=@repo.search(@name, 'Method Details')
      klass=rs[0] if rs.count==1
    end

    def component
      parent=@repo.get_element(@kernel.ParentID)
      @repo.get_element(parent.ClassifierID)
    end

    def is_call_operation?
      self.custom_property('kind')=='CallOperation'
    end

    def get_method
      result=nil
      xml_result=@repo.SqlQuery("select classifier_guid from t_object where object_id=#{self.elementid}")
      guid=xml_result[/classifier_guid\>(\{.+\})/,1]
      unless guid.nil? then
        method_kernel=@repo.GetMethodByGUID(guid)
        result=EA::Method.new(method_kernel,@repo)
      end
      result
    end

    def get_consumer
      result=nil
      m=self.get_method
      case m.stereotype
        when 'request/reply'
          result=get_reqreply_consumer
        when 'one-way-in'
          result=get_onewayin_consumer
        when 'one-way-out'
          result=get_onewayout_consumer
        default # without a stereotype, guess it is req/reply
          result=get_reqreply_consumer
      end
      result
    end

    def partition_classifier
      p=self.parent
      p=p.parent if p.is_a?(EA::ExpansionRegion)
      p.classifier unless p.nil?
    end

private

    def get_reqreply_consumer
      result=nil
      self.connectors.each do |c|
        if c.is_a?(EA::ControlFlow) then
          if c.target.eql?(self) then
            result=c.source
          end
        end
      end
      result
    end

    def get_onewayin_consumer
      get_reqreply_consumer
    end

    def get_onewayout_consumer
      result=nil
      self.connectors.each do |c|
        if c.is_a?(EA::ControlFlow) then
          if c.source.eql?(self) then
            result=c.target
          end
        end
      end
      result
    end

  end
end
