# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
#

module EA

  class Package < OLEDelegate
  	include EA::Container

    attr_reader :parent

    def initialize(kernel, repo)
      super(kernel, repo)
      @name = @kernel.name
      pid = @kernel.ParentID
      @parent=@repo.get_package(pid) unless pid==0
      begin
        init_collections
      rescue Exception => e
        $stderr.puts "Error initialising collections for '#{kernel.Name}' of type '#{kernel.Type}'"
        $stderr.puts e.message
      end
    end

    def method_missing(sym, *args, &block)
      super(sym, *args, &block)
    end

    def path
      if @parent.nil? then
        return "/"+name
      else
        return @parent.path+"/"+name
      end
    end

    def package_id
      @kernel.PackageID
    end

    def package_GUID
      @kernel.PackageGUID
    end

    def add_package(name)
      @packages.add_new(name,"Nothing")
    end

    def add_element(name, type)
      s_type=type.to_s
      s_type.sub!(/EA::/,'')
      @elements.add_new(name,s_type)
    end

    def move(new_parent)
      @kernel.ParentID=new_parent.PackageID
      @kernel.Update
      @parent=new_parent
    end

    def delete
      idx=@parent.packages.find(self)
      @parent.packages.delete_at(idx)
    end

    def package_id
      @kernel.PackageID
    end

    def ==(other)
      return false unless other.is_a? Package
      self.package_id==other.package_id
    end

    def eql?(other)
      return false unless other.is_a? Package
      self.package_id==other.package_id
    end

    def hash
      packageguid.hash
    end

  end

end
