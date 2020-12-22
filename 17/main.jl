function init(ndim :: Int)
   input = readlines("input.txt")

   dy = length(input)
   dx = length(input[1])

   active = Set{CartesianIndex{ndim}}()

   lI = oneunit(CartesianIndex{ndim})
   uI = CartesianIndex{ndim}(dx,dy,(1 for x in 1:ndim-2)...)

   for i in 1:dx, j in 1:dy
      if input[i][j] == '#'
         push!(active, CartesianIndex{ndim}(i,j,(1 for x in 1:ndim-2)...))
      end
   end
   lI, uI, active
end

function run(lI, uI, active)
   I1 = oneunit(lI)
   delta = -I1:I1
   Z = zero(lI)
   for t in 1:6
      next_active = typeof(active)()
      for I in (lI-t*I1):(uI+t*I1)
         active_count = 0
         cell_active = I in active
         for dI in delta
            if dI == Z
               continue
            end
            if I+dI in active
               active_count += 1
            end
         end
         if cell_active && ( active_count in [2,3] )
            push!(next_active, I)
         elseif active_count == 3
            push!(next_active, I)
         end
      end
      active = next_active
   end
   length(active)
end

println( run(init(3)...) )
println( run(init(4)...) )

