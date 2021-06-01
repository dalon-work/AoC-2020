
const card_pub_key = 15628416
const door_pub_key = 11161639
#= const card_pub_key = 5764801 =#
#= const door_pub_key = 17807724 =#
const subject_number = 7

function find_loop_size(pub_key)
   loop_size = 0
   value = 1
   while value != pub_key
      value *= subject_number
      value %= 20201227
      loop_size += 1
   end
   return loop_size
end

function encryption_key(subject_number, loop_size)
   value = 1
   for i in 1:loop_size
      value *= subject_number
      value %= 20201227
   end
   return value
end


card_loop_size = find_loop_size(card_pub_key)
door_loop_size = find_loop_size(door_pub_key)

println("card loop size: $(card_loop_size)")
println("door loop size: $(door_loop_size)")

door_ekey = encryption_key(card_pub_key, door_loop_size)
card_ekey = encryption_key(door_pub_key, card_loop_size)

@assert(door_ekey == card_ekey)
println("ekey $door_ekey")




