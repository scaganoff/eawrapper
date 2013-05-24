# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
#

# TODO: Check collection add/delete at top level. Seems to require Repo.Models.Refresh rather than Package.Update (who wrote this crap?)
# TODO: Element can contain sub-Elements so we should make this a Container - but without child packages.

module EA

  module Container
    attr_reader :packages, :elements
    def init_collections()
        @packages=Collection.new(@kernel.Packages, @repo, Package)
        @elements=Collection.new(@kernel.Elements, @repo, Element)
    end

    def get_child_package(name)
#      puts "DEBUG> get_child_package('#{name}')"
      result=nil
      @packages.refresh  #force a refresh as the WSDL generator does not refresh
      @packages.each do |p|
        if p.name==name then
          result=p
          break
        end
      end
      return result
    end

    def get_package_by_name(name)
 #     puts "DEBUG> get_package_by_name('#{name}')"
      a=name.split('/')
      begin; n=a.shift; end while n==''
      p=get_child_package(n)
      if a.empty? then
        return p
      else
        return p.get_package_by_name(a.join('/'))
      end
    end

    def get_child_element(name)
      result=nil
      @elements.each do |e|
        if e.name==name then
          result=e
          break
        end
      end
      return result
    end

    def get_element_by_name(name)
  #    puts "DEBUG> get_element_by_name('#{name}')"
      a=name.split('/')
      begin; n=a.shift; end while n==''
      if a.empty? then
        e=get_child_element(n)
        return e
      else
        p=get_child_package(n)
        p=get_child_element(n) if p.nil?
        return p.get_element_by_name(a.join('/'))
      end
    end

  end

end