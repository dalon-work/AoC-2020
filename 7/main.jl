
lines = open("input.txt") do file
   readlines(file)
end

const parent_re = r"(\w+ \w+) bags"
const children_re = r"(\d+) (\w+ \w+) bags?"

adj = Dict()

for line in lines
   l = split(line, " contain ")
   ch = split(l[2], ',')
   p = match(parent_re, l[1]).captures[1]
   adj[ p  ] = []
   for c in ch
      m = match(children_re, c)
      if m === nothing
         continue
      end

      d = parse(Int32,m.captures[1])
      ww = m.captures[2]

      push!(adj[ p ], (d,ww))
   end
end

adj_inv = Dict(adj)

for (key, value) in adj
   adj_inv[ key ] = []
   for v in value
      adj_inv[ v[2] ] = []
   end
end

for (key, value) in adj
   for v in value
      push!(adj_inv[ v[2] ], (v[1], key))
   end
end


println(adj["shiny gold"])

found_nodes = Set([ x[2] for x in adj_inv["shiny gold"] ])

next_nodes = found_nodes

while length(next_nodes) > 0
   found_nodes_tmp = []
   for n in next_nodes
      for (num, k) in adj_inv[n]
         if k in found_nodes
            continue
         end
         push!(found_nodes_tmp, k)
         push!(found_nodes, k)
      end
   end

   global next_nodes = found_nodes_tmp

end

println( length(found_nodes) )

function dfs(dict, node)
   println(node)
   sum = 0
   for (count, new_node) in dict[node]
      println("new $count, $new_node")
      sum += count + count * dfs(dict, new_node)
   end
   return sum
end

bag_count = dfs(adj, "shiny gold")

println(bag_count)











