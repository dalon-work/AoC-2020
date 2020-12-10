const window = Int64(25)

function check_value(number::Int64, slice)
   for (i,val1) in enumerate(slice)
      for val2 in slice[i+1:end]
         if number == val1 + val2
            return true
         end
      end
   end
   return false
end

function part1(lines)
   for i in window+1:length(lines)
      value = lines[i]
      if !check_value(lines[i], lines[i-window:i-1])
         return value
         break
      end
   end
end

function findminmax(slice)
   mmin = typemax(Int64)
   mmax = typemin(Int64)

   for s in slice
      mmin = min(s, mmin)
      mmax = max(s, mmax)
   end

   return (mmin, mmax)
end

function part2(value, prefix_sum)
   for i in 1:length(prefix_sum)
      for j in i+1:length(prefix_sum)
         if prefix_sum[j] - prefix_sum[i] == value
            return (i+1,j)
         end
      end
   end
end

lines = [ parse(Int64, line) for line in readlines(open("input.txt")) ]

value = part1(lines)
println("Part 1 $value")

prefix_sum = copy(lines)

prefix_sum[1] = 0
for i in 2:length(lines)
   prefix_sum[i] += prefix_sum[i-1]
end

(s,f) = part2(value, prefix_sum)

println(lines[s:f])

(mmin, mmax) = findminmax(lines[s:f])

println("Part 2: ", mmin + mmax)
