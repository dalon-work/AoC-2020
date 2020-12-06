function to_binary(c :: Char)
   if c == 'F'
      return '0'
   elseif c == 'B'
      return '1'
   elseif c == 'L'
      return '0'
   elseif c == 'R'
      return '1'
   end
   println(c)
   return '*'
end 

function get_seat_id(line)
   binary = map(to_binary, line)
   row = parse(Int32, binary[1:7], base=2)
   col = parse(Int32, binary[8:10], base=2)
   id = row*8 + col
   return id
end

lines = open("input.txt") do input
   readlines(input)
end

ids = Int32[]

for line in lines
   id = get_seat_id(line)
   push!(ids, id)
end

ids = sort(ids)

max_seat_id = ids[end]

println("max seat id $max_seat_id")
   
for i in ids[1]:ids[end]
   if !(i in ids)
      println("missing seat $i")
   end
end
