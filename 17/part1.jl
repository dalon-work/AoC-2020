input = readlines("input.txt")

dy = length(input)
dx = length(input[1])

active = Set{Tuple{Int,Int,Int}}()

lI = CartesianIndex{3}(1,1,1)
uI = CartesianIndex{3}(dx,dy,1)
I1 = oneunit(lI)
active_range = lI:I1

for i in 1:dx, j in 1:dy
   if input[i][j] == '#'
      push!(active, (i,j,1))
   end
end

for t in 1:6
   next_active = Set{Tuple{Int,Int,Int}}()
   global active_range = (lI-t*I1):(uI+t*I1)
   for I in active_range
      active_count = 0
      cell_active = Tuple(I) in active
      for i in -1:1, j in -1:1, k in -1:1
         if i == 0 && j == 0 && k == 0
            continue
         end
         if (I[1]+i,I[2]+j,I[3]+k) in active
            active_count += 1
         end
      end
      if cell_active && ( active_count in [2,3] )
         push!(next_active, Tuple(I))
      elseif active_count == 3
         push!(next_active, Tuple(I))
      end
   end
   global active = next_active
end

println(length(active))



