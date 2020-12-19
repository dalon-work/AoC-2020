function part1(input::Vector{UInt64}, count::Integer)
   count = UInt64(count)
   d = Dict{UInt64,UInt64}()

   turn = 1
   for i in input[1:end-1]
      d[i] = turn
      #= println("turn $turn num $i") =#
      turn += 1
   end

   last = input[end]

   for t in turn:count-1
      if !(last in keys(d))
         next = 0
      else
         next = t - d[last]
      end
      #= println("turn $t num $last") =#
      d[last] = t
      last = next
   end

   return last

end

input = [ UInt64(x) for x in [6, 13, 1, 15, 2, 0] ]

println(part1(input,2020))
@time println(part1(input,30000000))




