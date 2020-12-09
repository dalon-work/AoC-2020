using DataStructures: DefaultDict

contained = DefaultDict{SubString,Vector{SubString}}([])

function what_contains(color)
   result = Set()
   if haskey(contained, color)
      for c in contained[color]
         push!(result, c)
         result = union(result, what_contains(c))
      end
   end
   return result
end

for line in readlines(open("input.txt"))
   container = join(split(line)[1:2],' ')
   for inside in split(split(line,"contain ")[2],", ")
      color = join(split(inside)[2:3],' ')
      push!( contained[color], container )
   end
end

total = length(what_contains("shiny gold"))
println("Part1 $total")


