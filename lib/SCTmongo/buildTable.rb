# Author @gwzz
# building context table
# 
require 'set'
require 'fileutils'
require 'matrix'
# require 'mongo'

FileUtils::mkdir_p '/Users/zhuwei/Desktop/FCA/201409/context_table'

# #store nodes attributes in set
nodes_attributes = Hash.new { |hash, key| hash[key] = [] }
f=File.open("/Users/zhuwei/Desktop/FCA/201409/concept_attributes_active.txt","r")     
f.each_line {|line|
  line = line.tr_s('"', '').strip
  fields = line.split("\t")
  key = fields[0]
  value = fields[1].split(";").map{ |x| x.split(":")[1]}
  nodes_attributes[key] = value
}

# f=File.open("/Users/zhuwei/Desktop/FCA/201409/nodes.txt","r")
# f.each_line {|line|
#   fragment_nodes = line.split(",").map(&:strip)
  fragment_nodes = ["29736007","267425008","5388008","29512005","54250004"]
  # fragment_nodes = ["1899006","363080007","54905006","267425008","5388008","25744000","85995004","11164009","29736007"]
  attributes_set = []
  fragment_nodes.each do |fn|
    if nodes_attributes.has_key?(fn)
      attributes_set |= nodes_attributes[fn]
    end
  end

  m = []

  fragment_nodes.each do |fn|
    fn_att = nodes_attributes[fn]
    subarray = Array.new(attributes_set.size, 0)
    fn_att.each do |fa|
      subarray[attributes_set.index(fa)] = 1
    end
    m.push(subarray)
  end

  recycle = fragment_nodes & attributes_set

  recycle.each do |r|
    rIndex = attributes_set.index(r)
    m.each do |sm|
      subIndex = m.index(sm)
      if sm[rIndex] == 1
        sm = [sm,m[fragment_nodes.index(r)]].transpose.map{|x| x.reduce(:|)}
        m[subIndex] = sm
      end
    end
  end

  rIndex = []
  recycle.each do |r|
    rIndex << attributes_set.index(r)
  end

  rIndex.each do |i|
    m.each do |sm|
      sm[i] = nil
    end
  end

  m.map { |sm| sm.compact!  }
  m.each do |sm|
    p sm
  end


# File.open("/Users/zhuwei/Desktop/FCA/201409/concept_attributes_active.txt", "a+") do |f|

#   nodes.each do |node|
#     attributes = ""
#     terminology.find({sourceId:node.to_i}).each do |document|
#       if document[:active] != 0
#         attributes += document[:typeId].to_s + ":" + document[:destinationId].to_s + ";"
#       end
#     end
#     f.puts (node.to_s + "\t" + attributes)
#   end
# end