
seats = readlines("input.txt")
rows = length(seats) + 2
cols = length(seats[1]) + 2

col_start = 2
col_end = cols-1
row_start = 2
row_end = rows-1

Ifirst = CartesianIndex(col_start,row_start)
Ilast  = CartesianIndex(col_end, row_end)
Idx    = Ifirst:Ilast
I1     = oneunit(Ifirst)

floor = fill('.', (cols, rows, 2))

for (r,line) in enumerate(seats)
   for (c,ch) in enumerate(line)
      floor[c+1,r+1,:] .= ch
   end
end

const MID = CartesianIndex(2,2)

function change_empty_seat(floor)
   for i in CartesianIndices(floor)
      (i == MID) && continue
      if floor[i] == '#' 
         return 'L'
      end
   end
   return '#'
end

function change_occupied_seat(floor)
   sum = 0
   for i in CartesianIndices(floor)
      (i == MID) && continue
      if floor[i] == '#' 
         sum += 1
      end
      sum == 4 && return 'L'
   end
   return '#'
end

function iterate(floor)
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
            next[i] = change_empty_seat(cur[(i-I1):(i+I1)])
         else
            next[i] = change_occupied_seat(cur[(i-I1):(i+I1)])
         end
         if next[i] != cur[i]
            same = false
         end
      end
      (next,cur) = (cur,next)
   end
   return next
end

next = @time iterate(floor)

for i in 1:cols
   println(next[i,:])
end
println("n seats ", sum(next .== '#'))





