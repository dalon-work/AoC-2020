const north = [0,1]
const south = [0,-1]
const east  = [1,0]
const west  = [-1,0]
const compass = [ north, east, south, west ]

pos = [0,0]
dir = 1

for line in readlines("input.txt")
   action,val = line[1], parse(Int,line[2:end])
   if action == 'F'
      global pos .+= compass[dir+1] .* val
   elseif action == 'N'
      global pos .+= north .* val
   elseif action == 'S'
      global pos .+= south .* val
   elseif action == 'E'
      global pos .+= east .* val
   elseif action == 'W'
      global pos .+= west .* val
   elseif action == 'R'
      global dir = (dir + Int(val/90)) % 4   
   elseif action == 'L'
      global dir = (dir - Int(val/90)+4) % 4   
   end
end

println( sum(abs.(pos)) )
