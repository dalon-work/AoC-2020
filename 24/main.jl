struct HexIndex
   x :: Int32
   y :: Int32
   z :: Int32
end

import Base.:+

function +(a :: HexIndex, b :: HexIndex)
   return HexIndex( a.x + b.x, a.y + b.y, a.z + b.z)
end

function part1(input)
   e = HexIndex(+1, -1, 0)
   ne = HexIndex(+1, 0, -1)
   nw = HexIndex( 0, +1, -1)
   w = HexIndex(-1,+1,0)
   sw = HexIndex(-1,0,+1)
   se = HexIndex(0,-1,+1)

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
   return length(black)
end

input = readlines("input.txt")
println(part1(deepcopy(input)))



