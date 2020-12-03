
data = open("input.txt") do input
   lines = readlines(input)

   data = Int64[]
   for l in lines
      push!(data, parse(Int64,l) )
   end

   return data

end

for i in 1 : length(data)
   for j in i : length(data)
      for k in j : length(data)
         if data[i] + data[j] + data[k] == 2020
            println(data[i]*data[j]*data[k])
         end
      end
   end
end
