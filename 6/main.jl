function part1(groups)
   groups = [ replace(x, isspace => "") for x in groups ]

   sets = Set{Char}[]
   for g in groups
      s = push!(sets, Set{Char}(g) )
   end

   sum = 0
   for s in sets
      sum += length(s)
   end

   println("Part 1 $sum")
end

function part2(groups)
   groups = [ split(x,isspace) for x in groups ]

   sum = 0
   for g in groups
      g_sets = intersect(filter(x -> x != Set{Char}(),[ Set{Char}(p) for p in g ])...)
      sum += length(g_sets)
   end

   println("Part 2 $sum")

end

lines = open("input.txt") do input
   read(input,String)
end

groups = split(lines,"\n\n")

part1(groups)
part2(groups)



