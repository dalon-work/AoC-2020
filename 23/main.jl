#= circle = [ 3, 8, 9, 1, 2, 5, 4, 6, 7 ] =#
circle = [7, 1, 6, 8, 9, 2, 5, 4, 3]

function getdest(circle, cup)
   find_me = cup-1
   if find_me == 0
      find_me = 9
   end
   dest = findfirst(x->x==find_me, circle)
   if dest === nothing
      return getdest(circle, find_me)
   else
      return dest
   end
end

function run(circle, count)
   for i in 1:count
      cup = circle[1]
      pickup = copy(circle[ 2:4 ])
      deleteat!(circle, 2:4 )

      dest = getdest(circle, cup)
      for i in pickup
         dest += 1
         insert!(circle, dest, i)
      end

      circle = circshift(circle, -1)
   end
   return circle
end

result = run(circle,100)

o = findfirst(x->x==1, result)
result = circshift(result,-o+1)

println(result)



