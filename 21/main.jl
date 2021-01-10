using DataStructures

function read_input(name)
   foods = []
   lines = readlines(name)
   for line in lines
      ingredients, allergens = split(line, " (contains ")
      ingredients = Set(strip.(split(ingredients)))
      allergens = Set(strip.(split(allergens[1:end-1],", ")))
      push!(foods, (ingredients, allergens) )
   end
   return foods
end

allergen_to_recipe = DefaultDict( () -> Set() )

foods = read_input("input.txt")

for (recipe, allergens) in foods
   for a in allergens
      push!(allergen_to_recipe[a],recipe)
   end
end

possible = Dict()

for (allergen, recipes) in allergen_to_recipe
   possible[ allergen ] = intersect(recipes...)
end

while true
   all_are_one = true
   for (a, i) in possible
      if length(i) == 1
         ing = collect(i)[1]
         for (b, j) in possible
            if a == b
               continue
            end
            delete!(j, ing)
         end
      else
         all_are_one = false
      end
   end
   if all_are_one
      break
   end
end

for (a,i) in possible
   possible[a] = only(i)
end

recipes = [ f[1] for f in foods ]

for r in recipes
   for (allergen, ingredient) in possible
      delete!(r, ingredient)
   end
end

println(sum( length(r) for r in recipes ) )
println( join( [possible[key] for key in sort(collect(keys(possible)))], ',' ) )
