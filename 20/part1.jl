function parse_tile(tile)
   lines = split(tile,'\n')
   num = parse(Int,lines[1][6:end-1])
   @views lines = lines[2:end]
   pixels = BitArray{2}(undef,10,10)
   for i in 1:10, j in 1:10
      pixels[i,j] = lines[i][j] == '#'
   end
   return num => pixels

end

function edge_hash(ba)
   mask = 0
   for i in ba
      mask <<= 1
      mask |=  i
   end
   return mask
end

const north = 1
const south = 2
const east = 3
const west = 4

function compute_edge_ints(tile)
   # Read edges counter-clockwise
   # A rotation does not change the hash of an edge.
   # A flip reverses the edge
   ccw_n = tile[1,10:-1:1]
   ccw_s = tile[10,1:10]
   ccw_e = tile[10:-1:1,10]
   ccw_w = tile[1:10,1] 

   cw_n =  ccw_n[10:-1:1]
   cw_s =  ccw_s[10:-1:1]
   cw_e =  ccw_e[10:-1:1]
   cw_w =  ccw_w[10:-1:1]

   return edge_hash.([ ccw_n, ccw_s, ccw_e, ccw_w ]), edge_hash.([ cw_n, cw_s, cw_e, cw_w ])
end

tiles = Dict(parse_tile.(split(read(open("input.txt"),String), "\n\n")))

tile_to_ccw_edges = Dict()
tile_to_cw_edges = Dict()
ccw_edges_to_tile = Dict()
cw_edges_to_tile = Dict()

for (id,tile) in tiles
   ccw_edges, cw_edges = compute_edge_ints(tile)
   tile_to_ccw_edges[id] = ccw_edges
   tile_to_cw_edges[id] = cw_edges
   for (i,e) in enumerate(ccw_edges)
      #= println(id,' ',i,' ',e) =#
      if !(e in keys(ccw_edges_to_tile))
         ccw_edges_to_tile[e] = []
      end
      push!(ccw_edges_to_tile[e], (id,i) )
   end
   for (i,e) in enumerate(cw_edges)
      #= println(id,' ',i,' ',e) =#
      if !(e in keys(cw_edges_to_tile))
         cw_edges_to_tile[e] = []
      end
      push!(cw_edges_to_tile[e], (id,i) )
   end
end

tile_conn = Dict()
for k in keys(tiles)
   tile_conn[k] = Vector{Union{Any,Missing}}(missing,4)
end

for (e, tiles) in ccw_edges_to_tile
   if length(tiles) == 1
      tile, dir = tiles[1]
      if e in keys(cw_edges_to_tile)
         other, odir = cw_edges_to_tile[e][1]
         tile_conn[tile][dir] = (other, odir, false)
         tile_conn[other][odir] = (tile, dir, false)
      end
   elseif length(tiles) == 2
      tile, dir = tiles[1]
      other, odir = tiles[2]
      tile_conn[tile][dir] = (other, odir, true)
      tile_conn[other][odir] = (tile, dir, true)
   else
      @assert false
   end
end

part1_ans = 1
for (tile,conns) in tile_conn
   count = 0
   for c in skipmissing(conns)
         count += 1
   end
   if count == 2
      global part1_ans *= tile
   end
end
println(part1_ans)


