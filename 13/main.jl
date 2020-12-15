lines = readlines("input.txt")
earliest = parse(Int,lines[1])
buses = parse.(Int,filter(x -> !(x == "x"), split(lines[2],',')))
waits = buses .- (earliest .% buses)
min_bus = findmin(waits)
println(buses[min_bus[2]]*min_bus[1])
