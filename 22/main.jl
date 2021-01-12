using DataStructures

function read_deck(lines)
   q = Queue{Int}()
   for l in lines[2:end] enqueue!(q,parse(Int,l)) end
   return q
end

decks = read_deck.(split.(split(strip(read("input.txt",String)),"\n\n"),"\n"))

while all( length.(decks) .> 0 )
   a,b = dequeue!(decks[1]), dequeue!(decks[2])
   i = (b > a) + 1
   enqueue!(decks[i], max(a,b)), enqueue!(decks[i], min(a,b))
end

winner = decks[ length.(decks) .> 0 ][1]
println( sum(collect(length(winner):-1:1) .* winner) )
