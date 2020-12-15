const north = [0,1]
const south = [0,-1]
const east  = [1,0]
const west  = [-1,0]

pos = [0,0]
wp = [10,1]

function rrotate(pos, wp, val)
   local_csys = wp .- pos
   nsteps = Int(val/90)
   for i in 1:nsteps
      local_csys = [ local_csys[2], -local_csys[1] ]
   end
   pos .+ local_csys
end

function lrotate(pos, wp, val)
   local_csys = wp .- pos
   nsteps = Int(val/90)
   for i in 1:nsteps
      local_csys = [ -local_csys[2], local_csys[1] ]
   end
   pos .+ local_csys
end

function travel_to_wp(pos, wp, val)
   disp = wp .- pos
   pos .+= disp .* val
   return pos, pos .+ disp
end

for line in readlines("input.txt")
   action,val = line[1], parse(Int,line[2:end])
   if action == 'F'
      global pos,wp = travel_to_wp(pos, wp, val)
   elseif action == 'N'
      global wp .+= north .* val
   elseif action == 'S'
      global wp .+= south .* val
   elseif action == 'E'
      global wp .+= east .* val
   elseif action == 'W'
      global wp .+= west .* val
   elseif action == 'R'
      global wp = rrotate(pos, wp, val)
   elseif action == 'L'
      global wp = lrotate(pos, wp, val) 
   end 
end

println( sum(abs.(pos)) )
