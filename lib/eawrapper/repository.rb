# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 
require 'win32ole'
require 'eawrapper/mixins/database_queries'

module EA

  class Repository < OLEDelegate
    include DatabaseQueries
  	
  	attr_reader :models
  	
    def initialize(win32_repo)
      super(win32_repo, self)
      @models=Collection.new(@kernel.Models, self, Model)
    end

    def method_missing(sym, *args, &block)
      super(sym, *args, &block)
    end

    def Repository.open(filename)
      raise "File doesn't exist: '#{filename}'" unless File.exist? filename
      repo = WIN32OLE.new 'EA.Repository'
      fso=WIN32OLE.new('Scripting.FileSystemObject')
      path=fso.GetAbsolutePathName(filename)
      repo.OpenFile(path)
      Repository.new(repo)
    end

    def Repository.connect
      app=WIN32OLE.connect('EA.App')
      repo=app.Repository
      Repository.new(repo)
    end

    def close
      @kernel.CloseFile
    end

    def get_element(id)
      el=@kernel.GetElementByID(id)
      create_element(el)
    end

    def get_element_by_name(name)
      a=name.split('/')
      begin; n=a.shift; end while n==""
      m=get_model_by_name(n)
      m.get_element_by_name(a.join('/'))
    end

    def get_element_by_guid(guid)
      e=@kernel.GetElementByGUID(guid)
      create_element(e)
    end

    def get_package(id)
      p=@kernel.GetPackageByID(id)
      Package.new(p,self)
    end

    def get_package_by_name(name)
      a=name.split('/')
      begin; n=a.shift; end while n==""
      m=get_model_by_name(n)
      m.get_package_by_name(a.join('/')) 
    end

    def get_connector(id)
      c=self.GetConnectorByID(id)
      Connector.new(c,self)
    end

    def get_diagram(id)
      d=@kernel.GetDiagramByID(id)
      Diagram.new(d,self)
    end

    def get_diagram_by_name(name)
      a=name.split('/')
      diag_name=a.pop
      pkg_name=a.join('/')
      pkg=self.get_package_by_name(pkg_name)
      result=nil
      pkg.Diagrams.each do |d|
        if d.name==diag_name then
          result=Diagram.new(d,self,d.type)
          break
        end
      end
      result
    end

    def get_model_by_name(name)
      result=nil
      @models.each do |m|
        if m.name==name then
          result=m
          break
        end
      end
      return result
    end

    def get_component(name)
      rs=search(name,'Element Name')
      result=[]
      rs.each do |e|
        begin
          result << create_element(e) if e.Type=='Component'
        rescue
        end
      end
      return result.first if result.size==1
    end

    def get_elements(type_filter=nil)
      if @all_elements.nil? then
        result = @kernel.GetElementSet('',0)
        @all_elements=extract_elements(result)
      end

      result=[]
      if type_filter.nil? then
        result=@all_elements
      else
        result=@all_elements.find_all {|e| e.is_a?(type_filter)}
      end
    end

    def get_selected_element()
      create_element(@kernel.GetTreeSelectedObject)
    end

    def search(search_term, search_name='Simple')
      result = @kernel.GetElementsByQuery(search_name, search_term)
      extract_elements(result)
    end

    private
    def create_element(kernel)
      #puts "DEBUG>> Create element '#{kernel.name}'"
      klass=get_klass(kernel.Type)
      case klass.to_s               # case statement doesn't work with constants
      when "EA::Package"
        pkg_kernel=get_package_of_element(kernel)
        result=Package.new pkg_kernel,self
      else
        result=Element.new kernel,self,klass
      end
      result
    end

    #
    # Packages are associated with an internal Element. If we have that element
    # (e.g. via search) then we want to find the associated package and instantiate
    # that. Only way I can see to do that is iterate through  sibling packages
    # to find which one "owns" the given Element.
    #
    def get_package_of_element(kernel)
      parent_id=kernel.PackageID
      element_id=kernel.ElementID
      parent=@kernel.GetPackageByID(parent_id)
      parent.Packages.each do |pkg|
        return pkg if pkg.Element.ElementID==element_id
      end
    end

    def get_klass(type)
      begin
        klass=EA.const_get(type)
        return klass
      rescue Exception=>e
        puts "ERROR: unknown type '#{type}: #{e.message}'"
        return nil
      end
    end

    def extract_elements(elements)
      array=[]
      elements.each do |el|
        e = create_element(el)
        array << e unless e.nil?
      end
      array
    end
  end

end