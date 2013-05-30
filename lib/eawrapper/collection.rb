# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  class Collection < OLEDelegate

    def initialize(kernel, repo, element_type)
      super(kernel, repo)
      @klass=element_type
    end

    def size
      @kernel.Count
    end

    def [](idx)
      k = @kernel.GetAt(idx) if idx.is_a? Integer
      k = @kernel.GetByName(idx) if idx.is_a? String
      @klass.new(k, @repo)
    end

    def first
      self[0]
    end

    def last
      self[self.size-1]
    end

    def each
      @kernel.each do |k|
        e = @klass.new(k, @repo)
        yield e
      end
    end

    def add_new(name, type=nil)
      s_type=type.to_s
      s_type="Class" if s_type=="EA::Klass"
      s_type.gsub!(/EA::/,'')
      obj=@kernel.AddNew(name,s_type)
      obj.Update
      @kernel.Refresh

      # Create the ruby wrapper around the COM object.
      # Here we assume the new element is the same type as the
      # Collection. If we don't do this then we need to
      # enumerate every variation on Element etc.
      case @klass.to_s
      when "EA::Element" then
        result=Element.new(obj,@repo,type)
      when "EA::Package" then
        result=Package.new(obj,@repo)
      when "EA::Method" then
        result=EA::Method.new(obj,@repo)
      end
      result
    end

    # Find the index of a given object in this collection
    def find(obj)
      match=nil
      n=self.size
      for idx in 0...n do
        if self[idx]==obj then
          match=idx
          break
        end
      end
      match
    end

    def delete_at(idx)
      @kernel.DeleteAt(idx,true)
      @kernel.Refresh  #TODO: why doesn't this work?
    end

    def refresh
      @kernel.Refresh
    end

    # Return an array of collection elements filtered by a block condition
    # If no block is specified then all elements will be returned.
    def find_all
      result=[]
      self.each do |e|
        test=if block_given? then yield(e) else true end
        if test then
          result << e
        end
      end
      result
    end
  end

end