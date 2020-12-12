
seats = readlines("input.txt")
const rows = length(seats) + 2
const cols = length(seats[1]) + 2

const col_start = 2
const col_end = cols-1
const row_start = 2
const row_end = rows-1

const Ifirst = CartesianIndex(col_start,row_start)
const Ilast  = CartesianIndex(col_end, row_end)
const Idx    = Ifirst:Ilast
const I1     = oneunit(Ifirst)
const MID = CartesianIndex(2,2)

function build_floor()
   floor = fill('.', (cols, rows, 2))

   for (r,line) in enumerate(seats)
      for (c,ch) in enumerate(line)
         floor[c+1,r+1,:] .= ch
      end
   end
   floor
end

function change_empty_seat(floor, neighbors)
   for i in CartesianIndices(neighbors)
      (i == MID) && continue
      nbr = neighbors[i]
      nbr === nothing && continue
      if floor[nbr] == '#' 
         return 'L'
      end
   end
   return '#'
end

function change_occupied_seat(floor, neighbors, occupied_limit)
   sum = 0
   for i in CartesianIndices(neighbors)
      (i == MID) && continue
      nbr = neighbors[i]
      nbr === nothing && continue
      if floor[nbr] == '#' 
         sum += 1
      end
      sum == occupied_limit && return 'L'
   end
   return '#'
end

function iterate(floor, neighbors, occupied_limit)
   cur = @view floor[:,:,1]
   next = @view floor[:,:,2]
   same::Bool = false
   while !same
      println("n seats ", sum(cur .== '#'))
      same = true
      for i in Idx
         ch = cur[i]
         ch == '.' && continue
         if ch == 'L'
            next[i] = change_empty_seat(cur, neighbors[:,:,i])
         else
            next[i] = change_occupied_seat(cur, neighbors[:,:,i], occupied_limit)
         end
         if next[i] != cur[i]
            same = false
         end
      end
      (next,cur) = (cur,next)
   end
   return next
end

# Part1

function part1_neighbor_array(Idx, cols, rows)
   neighbors = Array{ Union{CartesianIndex{2}, Nothing},4}(nothing, 3,3, cols, rows)
   for i in Idx
      nbrs = @view neighbors[:,:,i]
      for j in CartesianIndices(nbrs)
         j == MID && continue
         nbrs[j] = i + (j-MID)
      end
   end
   return neighbors
end

floor = build_floor()
neighbors = part1_neighbor_array(Idx, cols, rows)
next = @time iterate(floor, neighbors, 4)
println("n seats ", sum(next .== '#'))

# Part2

function search(floor, i, dir)
   while true
      i += dir
      if ((i[1] < Ifirst[1]) || (i[1] > Ilast[1])) || ((i[2] < Ifirst[2]) || (i[2] > Ilast[2]))
         return nothing
      end

      if floor[i] == 'L' 
         return i
      end
   end
end

function part2_neighbor_array(floor, Idx, cols, rows)
   neighbors = Array{ Union{CartesianIndex{2}, Nothing},4}(nothing, 3,3, cols, rows)
   for i in Idx
      nbrs = @view neighbors[:,:,i]
      for j in CartesianIndices(nbrs)
         if j == MID 
            nbrs[j] = nothing
            continue
         end
         dir = j-MID
         nbrs[j] = search(floor,i,dir)
      end
   end
   return neighbors
end

floor = build_floor()
neighbors = part2_neighbor_array(floor[:,:,1], Idx, cols, rows)
next = @time iterate(floor, neighbors, 5)

#= for i in 1:rows =#
#=    println(next[i,:]) =#
#= end =#
println("n seats ", sum(next .== '#'))




