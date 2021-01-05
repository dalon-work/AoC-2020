# Part 1 most inspired (mostly copied?) from https://github.com/talentdeficit/aoc2020/blob/1bdc06f7428c8e8c59a2748fbd1c2fa0e04e67c5/bin/twenty/run.jl
# Although I think I did improve on it a little in small ways

struct Tile
   id :: Int
   pixels :: BitArray{2}
end

function parse_tile(tile)
   lines = split(tile,'\n')
   id = parse(Int,lines[1][6:end-1])
   @views lines = lines[2:end]
   pixels = BitArray{2}(undef,10,10)
   for i in 1:10, j in 1:10
      pixels[i,j] = lines[i][j] == '#'
   end
   return id => Tile(id,pixels)
end

north(tile::Tile) = tile.pixels[1,:]
south(tile::Tile) = tile.pixels[end,:]
east(tile::Tile) = tile.pixels[:, end]
west(tile::Tile) = tile.pixels[:,1]
flip(tile::Tile) = Tile(tile.id, tile.pixels[:,end:-1:1])
rotate(tile::Tile) = Tile(tile.id, rotl90(tile.pixels))
trim(tile::Tile) = tile.pixels[2:end-1,2:end-1]

function get_edges(tile::Tile)
   n = north(tile)
   s = south(tile)
   e = east(tile)
   w = west(tile)
   return n, s, e, w, reverse(n), reverse(s), reverse(e), reverse(w)
end

function get_all_edges(tiles)
   all_edges = Dict()
   for (tid, tile) in tiles
      edges = get_edges(tile)
      for e in edges
         if !haskey(all_edges,e)
            all_edges[e] = []
         end
         push!(all_edges[e],tid)
      end
   end
   return all_edges
end

function find_corners(tiles, edges)
   corners = []
   for (tid, tile) in tiles
      c = sum( length.( [edges[ north(tile) ], edges[ south(tile) ], edges[ east(tile) ], edges[ west(tile) ] ]) )
      if c == 6
         push!(corners, tid)
      end
   end
   return corners
end

function orient_first_corner(tile, edges)
   for _ in 1:4
      t = edges[ north(tile) ]
      w = edges[ west(tile) ]
      if length(t) == 1 && length(w) == 1
         return tile
      end
      tile = rotate(tile)
   end
   return tile
end

function orient(tile, edges, matcher)
   for flipped in (false, true)
      if flipped
         tile = flip(tile)
      end
      for _ in 1:4
         if matcher(tile)
            return tile
         end
         tile = rotate(tile)
      end
   end
end

function assemble(tiles, edges, first_tile_id)
   rows = []
   first_tile = orient_first_corner( tiles[first_tile_id], edges )
   row = [first_tile]
   current = first_tile

   while !( current === nothing )
      next_edge_list = edges[ east(current) ]
      if length(next_edge_list) == 2
         next_id = only( filter(id -> id != current.id, next_edge_list) )
         next = orient(tiles[next_id], edges, (t) -> west(t) == east(current))
         push!(row, next)
         current = next
      else
         push!(rows, hcat(map(tile -> trim(tile),row)...))
         current = row[1]
         next_edge_list = edges[ south(current) ]
         if length(next_edge_list) == 2
            next_id = only( filter(id -> id != current.id, next_edge_list) )
            next = orient(tiles[next_id], edges, (t) -> north(t) == south(current))
            current = next
            row = [current]
         else
            current = nothing
         end
      end
   end
   return vcat(rows...)
end

function get_seamonster_list()
   lb_signs = Vector{CartesianIndex{2}}()
   lines = readlines("seamonster.txt")
   y = length(lines)
   x = length(lines[1])
   for i in 1:y
      for j in 1:x
         if lines[i][j] == '#'
            push!(lb_signs, CartesianIndex{2}(i,j))
         end
      end
   end
   return lb_signs, (y,x)
end

function find_seamonsters(seamap, seamonster, s)
   dy,dx = s
   target = length(seamonster)
   for flipped in (false, true)
      if flipped
         seamap = seamap[:,end:-1:1]
      end
      for r in 1:4
         my,mx = size(seamap)
         count = 0
         for i in 1:my-dy
            for j in 1:mx-dx
               subview = @view seamap[i:i+dy, j:j+dx]
               if sum(subview[seamonster]) == target
                  count += 1
               end
            end
         end
         if count > 0
            return count
         end
         seamap = rotl90(seamap)
      end
   end
end

const tiles = Dict(parse_tile.(split(strip(read(open("input.txt"),String)), "\n\n")))
const tile_ids = collect(keys(tiles))
const edges = get_all_edges(tiles)
const corners = find_corners(tiles, edges)
println( reduce(*,corners) )
const seamap = assemble(tiles, edges, corners[1])
const seamonster, s = get_seamonster_list()
println(sum(seamap) - length(seamonster)*find_seamonsters(seamap, seamonster,s))

