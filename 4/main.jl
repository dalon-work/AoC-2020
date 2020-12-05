function validate_byr(min :: Integer, max :: Integer, v :: AbstractString) :: Bool
   r = r"^(\d{4})$"
   m = match(r,v)
   if m === nothing
      return false
   else
      byr = parse(Int32,m.captures[1])
      return min <= byr <= max
   end
end

const hgt_re = r"^(\d+)(cm|in)$"
function validate_hgt(v :: AbstractString) :: Bool
   m = match(hgt_re, v)
   if m === nothing
      return false
   else
      c = m.captures
      val = parse(Int32,c[1])
      unit = c[2]
      if unit == "cm"
         return 150 <= val <= 193
      elseif unit == "in"
         return 59 <= val <= 76
      else
         return false
      end
   end
end

const hcl_re = r"^#[0-9a-f]{6}$"
const pid_re = r"^[0-9]{9}$"

const validator = Dict( "byr" => (v) -> validate_byr(1920,2002,v),
                        "iyr" => (v) -> validate_byr(2010,2020,v),
                        "eyr" => (v) -> validate_byr(2020,2030,v),
                        "hgt" => validate_hgt,
                        "hcl" => (v) -> occursin(hcl_re,v),
                        "ecl" => (v) -> v in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
                        "pid" => (v) -> occursin(pid_re,v),
                        "cid" => (v) -> true )

function check_passport_part1(pp)
   KEYS = ["byr","iyr","eyr","hgt","hcl","ecl","pid"]
   tags = [ x[1] for x in pp ]

   for k in KEYS
      if !(k in tags)
         return false
      end
   end
   return true
end

function check_passport_part2(pp)
   for kv in pp
      if !validator[ kv[1] ](kv[2])
         return false
      end
   end
   return true
end

s = open("input.txt") do file
   read(file,String)
end

passports = [ map( w -> split(w,":"), split(pp)) for pp in split(s, "\n\n") ]

good = filter( x -> check_passport_part1(x), passports )
println("Part1: ",length(good))

good = filter( x -> check_passport_part2(x), good )
println("Part2: ", length(good))



