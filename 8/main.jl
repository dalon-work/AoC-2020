const accum = Ref{Int64}(0)

@enum Asm begin
   nop = 1
   jmp
   acc
end

nopf(x::Int64) :: Int64 = 1
jmpf(x::Int64) :: Int64 = x

function accf(x::Int64) :: Int64
   accum[] += x
   return 1
end

const asmf = [ nopf, jmpf, accf ]

function to_asm(asm :: AbstractString) :: Asm
   if asm == "nop"
      return nop
   elseif asm == "jmp"
      return jmp
   elseif asm == "acc"
      return acc
   end
end

function vm(lines)
   end_line = length(lines)+1
   lines_seen = BitSet()
   cur_line = 1
   while true
      cur_line in lines_seen && error("Found loop")
      cur_line == end_line && break

      push!(lines_seen, cur_line)
      (asm, val) = lines[cur_line]
      move = asmf[ Int(asm) ](val)
      cur_line += move
   end
   return accum[]
end

lines = open("input.txt") do file
   asmlines = Vector{ Tuple{Asm, Int64} }()
   lines = readlines(file)
   for line in lines
      (asm, val) = split(line)
      val = parse(Int64,val)
      asm = to_asm(asm)
      push!(asmlines, (asm, val))
   end
   asmlines
end

try
   vm(lines)
catch err
   println("Part1 ", accum[])
end


replace_lines = Vector{Tuple{Int64, Tuple{Asm, Int64}}}()

for (i, (asm, val)) in enumerate(lines)
   if asm == nop
      push!(replace_lines,  (i, (jmp, val) ) )
   elseif asm == jmp
      push!(replace_lines,  (i, (nop, val) ) )
   end
end

for (i, val) in replace_lines
   accum[] = 0
   new_lines = copy(lines)
   new_lines[ i ] = val
   try 
      vm(new_lines)
   catch err
      continue
   end
   println("Part2 ", accum[], " $i $val")
   break
end
