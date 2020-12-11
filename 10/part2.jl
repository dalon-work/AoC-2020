include("main.jl")

using Memoize

nplugs = length(plugs)

@memoize function count_paths(i :: Int64) :: Int64
   mysum::Int64 = 0
   if i == nplugs
      return 1
   end

   for j = 1:3
      ind = i+j
      ind > nplugs && break
      if plugs[ind] - plugs[i] <= 3
         mysum += count_paths(ind)
      end
   end
   return mysum
end

sort!(plugs)
npaths = count_paths(1)

println(npaths)

