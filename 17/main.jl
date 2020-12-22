function init(ndim :: Int)
   input = readlines("input.txt")

   dy = length(input)
   dx = length(input[1])

   active = Set{Tuple{(Int for x in 1:ndim)...}}()

   lI = CartesianIndex{ndim}((1 for x in 1:ndim)...)
   uI = CartesianIndex{ndim}(dx,dy,(1 for x in 1:ndim-2)...)

   for i in 1:dx, j in 1:dy
      if input[i][j] == '#'
         push!(active, (i,j,(1 for x in 1:ndim-2)...))
      end
   end
   lI, uI, active
end

function run(lI, uI, active)
   I1 = oneunit(lI)
   active_range = lI:I1
   delta = -I1:I1
   Z = zero(lI)
   for t in 1:6
      next_active = typeof(active)()
      active_range = (lI-t*I1):(uI+t*I1)
      for I in active_range
         active_count = 0
         cell_active = Tuple(I) in active
         for dI in delta
            if dI == Z
               continue
            end
            if Tuple(I+dI) in active
               active_count += 1
            end
         end
         if cell_active && ( active_count in [2,3] )
            push!(next_active, Tuple(I))
         elseif active_count == 3
            push!(next_active, Tuple(I))
         end
      end
      active = next_active
   end
   length(active)
end

println( run(init(3)...) )
println( run(init(4)...) )

