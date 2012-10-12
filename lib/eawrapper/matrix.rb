# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 

module EA

  class Matrix
    def initialize(rows, columns, args={:row_name=>:qname, :column_name=>:name})
      @data={}

      @args=args
      @args[:row_name]=:qname unless @args.has_key?(:row_name)
      @args[:column_name]=:name unless @args.has_key?(:column_name)

      @row_names=rows.map {|e| e.send(args[:row_name]) }
      @column_names=columns.map {|e| e.send(args[:column_name])}
      @row_names.each do |rn|
        @data[rn]={}
        @column_names.each {|cn| @data[rn][cn]=nil }
      end
    end

    def add(element, columns)
      row=@data[element.send(@args[:row_name])]
      columns.each do |cpt|
        row[cpt.send(@args[:column_name])]=1
      end
    end

    def to_csv
      csv=","<<@column_names.join(',')<<"\n"
      @row_names.each do |rn|
        csv<<rn<<','<<@data[rn].values.join(',')<<"\n"
      end
      csv
    end
  end

end