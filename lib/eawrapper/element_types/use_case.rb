# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  # Mixin for UseCase (as a type of Element)
  module UseCase

    def qname(delim=':')
      p=path
      a=p.split('/')
      domain=a[4]
      return [domain,name].join(delim)
    end

    def components
      result=[]
      @kernel.Connectors.each do |c|
        [:clientID, :supplierID].each do |endpt|
          e=@repo.get_element(c.send(endpt))
          result << e if e.is_a? Component
        end
      end
      result
    end

    # Returns a list of rqts realized by this Use-Case if the
    # realization arrow has been drawn from the Use-Case to the Requirement.
    def requirements
      rqts=[]
      self.connectors.each do |c|
        if c.type=='Realisation' or c.type=='Realization' then
          rq=@repo.get_element(c.supplierid)
          rqts<<rq if rq.type=='Requirement'
        end
      end
      rqts
    end

  end
end