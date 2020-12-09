
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

function part1_vm(lines)
   lines_seen = Set()
   cur_line = 1
   while true
      cur_line in lines_seen && break
      push!(lines_seen, cur_line)
      (asm, val) = lines[cur_line]
      move = asmf[ Int(asm) ](val)
      cur_line += move
   end
   println("Part 1: ", accum[])
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

part1_vm(lines)





