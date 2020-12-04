lines = open("input.txt") do input
   readlines(input)
end

function run_slope(lines, dx, dy)
   l = lines[1]
   n_char = length(l)
   n_rows = length(lines)
   x = 1
   y = 1
   n_trees = 0

   while y <= n_rows
      l = lines[y]
      test_char = lines[y][x]
      n_trees += ( test_char == '#' )
      x += dx
      y += dy
      if x > n_char
         x -= n_char
      end
   end
   return n_trees
end

slopes = [ (1,1), (3,1), (5,1), (7,1), (1,2) ]

total = 1
for (dx,dy) in slopes
   n_trees = run_slope(lines,dx,dy)
   global total *= n_trees
   println("(dx,dy): ($dx,$dy) n_trees: $n_trees")
end

println("product: $total")






