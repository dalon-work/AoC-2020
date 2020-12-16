lines = readlines("input.txt")
#= earliest = parse(Int,lines[1]) =#

buses = Vector{Int}()
indices = Vector{Int}()
for (i,l) in enumerate(split(lines[2],','))
   if !(l == "x")
      push!(indices, i-1)
      push!(buses, parse(Int,l))
   end
end
println(buses,indices)

first = buses[1]
buses = buses[2:end]
indices = indices[2:end]

coeff = [ (first, b, i) for (b, i) in zip(buses, indices) ]

function create_arithmetic_progression(f, b, i)
   n = 1
   while true
      fn = b*n - i
      m = fn % first
      if fn % first == 0
         return (fn, first * b, b)
      end
      n += 1
   end
end

seq = [ create_arithmetic_progression(c...) for c in coeff ]

function intersect_seq(s1, s2)
   for n in 1:1000
      fn = s1[1] + s1[2]*n
      if (fn - s2[1]) % s2[2] == 0
         return (fn, s1[2] * s2[3], s1[2])
      end
   end
end

new_seq = seq[1]
for n in 2:length(seq)
   global new_seq = intersect_seq(new_seq, seq[n] )
   println(new_seq)
end

