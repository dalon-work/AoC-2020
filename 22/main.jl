function read_deck(lines)
   q = Vector{Int}()
   for l in lines[2:end] push!(q,parse(Int,l)) end
   return q
end

decks = read_deck.(split.(split(strip(read("example.txt",String)),"\n\n"),"\n"))

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

function play_recursive_combat_crab(decks, game)
   global g_game
   my_game = game
   println("=== Game $my_game ===")
   println()
   seen = Set()
   round = 1
   while all( length.(decks) .> 0 )
      println("-- Round $round (Game $my_game) --")
      println("Player 1's deck: $(decks[1])")
      println("Player 2's deck: $(decks[2])")
      tmp = Tuple([(decks...)...])
      if tmp in seen
         println("Configuration seen before, Player 1 wins!")
         return 0
      end
      push!(seen, tmp)
      top = popfirst!.(decks)
      println("Player 1 plays: $(top[1])")
      println("Player 2 plays: $(top[2])")
      if all( length.(decks) .>= top )
         new_decks = [ decks[1][1:top[1]], decks[2][1:top[2]] ]
         println("Playing a sub-game to determine the winner...")
         println()
         i = play_recursive_combat_crab(new_decks, g_game[]+1)
         g_game += 1
         println("...anyway, back to game $my_game.")
      else
         i = (top[2] > top[1])
      end
      println("Player $(Int(i+1)) wins round $round of game $(my_game)!")
      push!(decks[i+1], top[i+1]), push!(decks[i+1], top[xor(i,1)+1])
      println()
      round += 1
   end
   winner = only(findall((x) -> length(x) > 0 , decks))
   println("The winner of game $my_game is player $(winner)!")
   println()
   return winner - 1
end

winner = decks[ play_recursive_combat_crab(decks, g_game) + 1 ]
println( sum(collect(length(winner):-1:1) .* winner) )

