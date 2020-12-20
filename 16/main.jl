function parse_input(input)
   input = read(input,String)
   fields, my_ticket, nearby_tickets = split(input, "\n\n")

   fields_dict = Dict()

   for fline in split(fields,'\n')
      field, ranges = split(fline,": ")
      fields_dict[field] = [eval(Meta.parse(replace(x,'-' => ':'))) for x in split(ranges, " or ") ]
   end

   my_ticket = parse.(Int,split(split(my_ticket,'\n')[2],','))
   nearby_tickets = split(nearby_tickets,'\n')[2:end-1]
   nearby_tickets = [ parse.(Int,split(x,',')) for x in nearby_tickets ]

   return fields_dict, my_ticket, nearby_tickets
end

fields, mine, others = parse_input("input.txt")

all_ranges = [ (values(fields)...)... ]

invalid = []

valid_tickets = []

for o in others
   valid_ticket = true
   for x in o
      if all( !(x in r) for r in all_ranges )
         push!(invalid, x)
         valid_ticket = false
      end
   end
   if valid_ticket
      push!(valid_tickets,o)
   end
end

println(sum(invalid))
others = hcat(valid_tickets...)
#= println(typeof(others)) =#

function check_is_valid(x,rs)
   any( (x in r) for r in rs)
end

possible_fields = []

for i in 1:size(others,1)
   pfields = Set()
   for (k,v) in fields
      if all( check_is_valid.(others[i,:],Ref(v) ))
         push!(pfields, k)
      end
   end
   push!(possible_fields,pfields)
end

deleted = Set()

while any( length(ff) != 1 for ff in possible_fields )
   for i in 1:length(possible_fields)
      #= println(i,' ', possible_fields[i]) =#
      if length(possible_fields[i]) == 1
         field = collect(possible_fields[i])[1]
         if field in deleted
            continue
         end

         for j in 1:length(possible_fields)
            if i == j
               continue
            end
            delete!(possible_fields[j],field)
         end
         push!(deleted,field)
      end
   end
end

found_fields = [ (possible_fields...)... ]

prod = 1
for (m,ff) in zip(mine,found_fields)
   println(ff)
   if startswith(ff,"departure")
      global prod *= m
   end
end
println(prod)
      

