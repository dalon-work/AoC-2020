function parse_mask(mask)
   set_mask = zero(UInt64)
   clear_mask = zero(UInt64)
   floating_bits = Vector{UInt64}()
   bit = 35
   for c in mask
      set_mask = set_mask << 1
      clear_mask = clear_mask << 1
      if c == '0'
         clear_mask |= one(UInt64)
      elseif c == '1'
         set_mask |= one(UInt64)
      elseif c == 'X'
         push!(floating_bits, one(UInt64) << bit)
      end
      bit -= 1
   end
   (set_mask, ~clear_mask, floating_bits)
end

const mem_re = r"^mem\[(\d+)\] = (\d+)$"

function parse_mem_op(line)
   m = match(mem_re, line)
   vals = parse.(UInt64,m.captures)
   vals[1], vals[2]
end

function part1(lines)
   mem = Dict{UInt64, UInt64}()
   set_mask = zero(UInt64)
   clear_mask = zero(UInt64)

   for l in lines
      if startswith(l,"mask")
         set_mask, clear_mask, floating_bits = parse_mask(split(l)[3])
      else
         addr,val = parse_mem_op(l)
         mem[addr] = (val | set_mask) & clear_mask
      end
   end

   sum( kv[2] for kv in mem )
end

function floating_mem_set(mem, addr, val, floating_bits)
   if length(floating_bits) == 0
      mem[addr] = val
      return
   end

   mask = floating_bits[1]
   new_floating_bits = floating_bits[2:end]

   floating_mem_set(mem, addr | mask, val, new_floating_bits)
   floating_mem_set(mem, addr & ~mask, val, new_floating_bits)
end


function part2(lines)
   mem = Dict{UInt64, UInt64}()
   set_mask = zero(UInt64)
   clear_mask = zero(UInt64)
   floating_bits = Vector{UInt64}()

   for l in lines
      if startswith(l,"mask")
         set_mask, clear_mask, floating_bits = parse_mask(split(l)[3])
      else
         addr,val = parse_mem_op(l)
         floating_mem_set(mem, addr | set_mask, val, floating_bits)
      end
   end

   sum( kv[2] for kv in mem )
end

lines = readlines("input.txt")

println( part1(lines) )
println( part2(lines) )
