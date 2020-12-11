using StatsBase
plugs = [0; parse.(Int64,readlines("input.txt")) ]
push!(plugs, findmax(plugs)[1]+3)
value = mapreduce((x)->x[2], *, countmap(diff(sort(plugs))))
println(value)
