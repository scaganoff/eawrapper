# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 
#
module EA

  module TreeNav

    def parent
      result=nil
      pid=@kernel.ParentID
      result=@repo.get_element(pid) unless pid==0
      result
    end

    def package
      result=nil
      pid=@kernel.PackageID
      result=@repo.get_package(@kernel.PackageID)
      result
    end

    def has_ancestor_package?(package_path)
      if self.is_a?(EA::Package) then
        pkg=self
      else
        pkg=self.package
      end
      result=false
      until pkg.nil?
        if pkg.path==package_path then
          result=true
          break
        else
          pkg=pkg.parent
        end
      end
      result
    end

  end

end