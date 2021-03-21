function read_deck(lines)
   q = Vector{Int}()
   for l in lines[2:end] push!(q,parse(Int,l)) end
   return q
end

decks = read_deck.(split.(split(strip(read("input.txt",String)),"\n\n"),"\n"))

function play_combat_crab(decks)
   decks = deepcopy(decks)
   while all( length.(decks) .> 0 )
      a,b = popfirst!.(decks)
      i = (b > a) + 1
      push!(decks[i], max(a,b)), push!(decks[i], min(a,b))
   end
   winner = only(decks[ length.(decks) .> 0 ])
   return sum(collect(length(winner):-1:1) .* winner)
end

#= println( play_combat_crab(decks) ) =#

g_game = 1

function play_recursive_combat_crab(decks)
   winner = -1
   win = false
   hist = []
   while !win
      if decks in hist
         return 0
      end
      push!(hist, [ copy(decks[1]), copy(decks[2]) ] )
      draws = popfirst!.(decks)
      if (draws[1] <= length(decks[1])) && (draws[2] <= length(decks[2]))
         winner = play_recursive_combat_crab([ copy(decks[1][1:draws[1]]), copy(decks[2][1:draws[2]]) ] )
      else
         winner = Int(draws[1] < draws[2])
      end

      push!( decks[winner+1], draws[winner+1])
      push!( decks[winner+1], draws[xor(winner,1)+1])
      win = length(decks[1]) == 0 || length(decks[2]) == 0
   end
   println(winner)
   return winner
end

winner = decks[ play_recursive_combat_crab(decks)+1 ]
println( sum(collect(length(winner):-1:1) .* winner) )

