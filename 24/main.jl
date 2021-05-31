struct HexIndex
   x :: Int32
   y :: Int32
   z :: Int32
end


import Base.:+
import Base.:typemax
import Base.:typemin
import Base.:min
import Base.:max

typemax(a :: Type{HexIndex}) = HexIndex( typemax(Int32), typemax(Int32), typemax(Int32) )
typemin(a :: Type{HexIndex}) = HexIndex( typemin(Int32), typemin(Int32), typemin(Int32) )

function +(a :: HexIndex, b :: HexIndex)
   return HexIndex( a.x + b.x, a.y + b.y, a.z + b.z)
end

function min(a :: HexIndex, b::HexIndex)
   return HexIndex( min(a.x, b.x), min(a.y, b.y), min(a.z, b.z) )
end

function max(a :: HexIndex, b::HexIndex)
   return HexIndex( max(a.x, b.x), max(a.y, b.y), max(a.z, b.z) )
end

const e = HexIndex(+1, -1, 0)
const ne = HexIndex(+1, 0, -1)
const nw = HexIndex( 0, +1, -1)
const w = HexIndex(-1,+1,0)
const sw = HexIndex(-1,0,+1)
const se = HexIndex(0,-1,+1)

function part1(input)

   black = Set()

   for line in input
      nchar = length(line)
      pos = HexIndex(0,0,0)
      i = 1
      while i <= nchar
         c = line[i]
         if c == 'e'
            pos = pos + e
            i += 1
         elseif c == 'w'
            pos = pos + w
            i += 1
         elseif c == 'n'
            c2 = line[i+1]
            if c2 == 'e'
               pos = pos + ne
            else
               pos = pos + nw
            end
            i += 2
         else 
            c2 = line[i+1]
            if c2 == 'e'
               pos = pos + se
            else
               pos = pos + sw
            end
            i += 2
         end
      end

      if pos in black
         delete!(black, pos)
      else
         push!(black, pos)
      end
   end
   return black
end

function part2(black, ndays)
   black = deepcopy(black)
   for t in 1:ndays
      println("Day $t")
      new = Set()

      hmax = typemin(HexIndex)
      hmin = typemax(HexIndex)

      for hex in black
         hmax = max(hmax, hex)
         hmin = min(hmin, hex)
      end

      for x in hmin.x-1:hmax.x+1
         for y in hmin.y-1:hmax.y+1
            z = -x-y
            hidx = HexIndex(x,y,z)
            nblack = 0
            if hidx + nw in black 
               nblack += 1
            end
            if hidx + ne in black 
               nblack += 1
            end
            if hidx + se in black 
               nblack += 1
            end
            if hidx + sw in black 
               nblack += 1
            end
            if hidx + e  in black 
               nblack += 1
            end
            if hidx + w in black 
               nblack += 1
            end
            if hidx in black
               if nblack == 1 || nblack == 2
                  push!(new, hidx)
               end
            else
               if nblack == 2
                  push!(new, hidx)
               end
            end
         end
      end
      black = deepcopy(new)
      println("$t ", length(black))
   end
   return black
end


input = readlines("input.txt")
black = part1(deepcopy(input))
println(length(black))

black = part2(black, 100)

println(length(black))


