
function run(circle, count)
   list = deepcopy(circle)
   for i in 1:length(list)-1
      list[circle[i]] = circle[i+1]
   end
   list[circle[end]] = circle[1]

   last = findmax(circle)[1]

   p = zeros(Int32, 3)
   
   cup = circle[1]
   for i in 1:count
      # pickup the next 3 cups
      p[1] = list[ cup ]
      p[2] = list[ p[1] ]
      p[3] = list[ p[2] ]

      # pick the next destination
      dest = cup-1
      if dest == 0
         dest = last
      end

      while dest in p
         dest -= 1
         if dest == 0
            dest = last
         end
      end

      # insert the 3 cups into the list
      old = list[dest]
      list[cup] = list[ p[3] ]
      
      list[dest] = p[1]
      list[ p[3] ] = old

      cup = list[cup]
   end

   # Now rewrite circle in the correct order
   cup = list[1]
   for i in 1:length(list)
      next = list[cup]
      circle[i] = next
      cup = next
   end
      
   return circle
end

# part 1
#= circle = [ 3, 8, 9, 1, 2, 5, 4, 6, 7 ] =#
circle = [7, 1, 6, 8, 9, 2, 5, 4, 3]

result = run(circle,100)
idx = findall( x -> x == 1 , result )[1]
result = circshift(result,(-idx+1))
println("Part 1: ",result)

# part 2
#= circle = [ 3, 8, 9, 1, 2, 5, 4, 6, 7 ] =#
circle = [7, 1, 6, 8, 9, 2, 5, 4, 3]
for i in 10:1_000_000
   push!(circle,i)
end

result = run(circle,10_000_000)
idx = findall( x -> x == 1 , result )[1]
result = circshift(result,(-idx+1))
println("Part 2: ",result[2]*result[3])






