# 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
# A----------------------------------
#     B----------- C-----------
#                      D-----

class Node
  property children : Array(Node)
  property metadata : Array(Int32)

  def initialize
    @children = [] of Node
    @metadata = [] of Int32
  end
end

class Tree
  property :root

  def initialize(data : Array(Int32))
    @root = Node.new
    build_nodes(data, @root)
  end

  def build_nodes(data : Array(Int32), node : Node)
    child_count, metadata_count = data # 2, 3
    data_end = 2 # minus 2 for header
    child_count.times do # 2.times
      child = Node.new
      data_end += build_nodes(data[data_end..-1], child) # [0, 3, ...]
      node.children << child
    end
    node_size = data_end + metadata_count
    node.metadata = data[data_end..node_size-1]
    node_size
  end
  
  def traverse(node, value)
    value += node.metadata.reduce { |a, b| a + b } if node.children.size == 0
    node.metadata.each do |index|
      next if index - 1 >= node.children.size
      value += traverse(node.children[index - 1], 0)
    end
    value
  end

  def value_sum
    value = 0
    traverse(@root, value)
  end
end

f=File.read("8.in")
arr = f.split(" ").map { |e| e.to_i }
t = Tree.new(arr)
p t.value_sum
