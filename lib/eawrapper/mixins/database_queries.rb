# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 
#

module EA

  module DatabaseQueries

    def find_in_diagrams(object_id)
      result=[]
      xml_result=@repo.SqlQuery("select t_diagram.ea_guid from t_diagramobjects left join t_diagram on t_diagramobjects.Diagram_ID=t_diagram.Diagram_ID where object_id=#{object_id}")
      rows=xml_result.split('<Row>')
      guids=rows[1..-1].map {|r| r[/ea_guid\>(\{.+\})/,1] }
      guids.each do |guid|
        kernel=@repo.GetDiagramByGUID(guid)
        result<<Diagram.new(kernel,@repo)
      end
      result
    end

  end

end

