using Distributed

@everywhere struct PasswordPolicy
   min :: Int32
   max :: Int32
   ch  :: Char
end

@everywhere function nows( line :: AbstractString ) :: SubString
   i = 1
   for ch in line
      if ch in [ ' ', '\t', '\n' ]
         i += 1
         continue
      else
         return SubString(line, i)
      end
   end
end

@everywhere function integer(line :: AbstractString)
   i = 1
   for ch in line
      if ch in [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ]
         i += 1
      else
         break
      end
   end

   int = parse(Int32, SubString(line,1,i-1))

   return SubString(line, i), int
end

@everywhere function char(line :: AbstractString, ch :: Char) :: SubString
   if line[1] == ch
      return SubString(line, 2)
   else
      return line
   end
end

@everywhere function char(line :: AbstractString)
   ch = line[1]
   return SubString(line, 2), ch
end

@everywhere function parseline( line :: String )
   line = nows(line)
   line, min = integer(line)
   line = char(line, '-')
   line, max = integer(line)
   line = nows(line)
   line, ch = char(line)
   line = char(line, ':')
   line = nows(line)
   return PasswordPolicy(min, max, ch), line
end

@everywhere function check_password_part_1(policy :: PasswordPolicy, password :: AbstractString) :: Bool
   count = 0
   for ch in password
      if ch == policy.ch
         count += 1
         if count > policy.max
            return false
         end
      end
   end
   return count >= policy.min
end

@everywhere function check_password_part_2(policy :: PasswordPolicy, password :: AbstractString) :: Bool
   min = (password[policy.min] == policy.ch) 
   max = (password[policy.max] == policy.ch)
   xor(min,max)
end

@everywhere function parse_and_check_password(line, checker) :: Int32
   policy, password = parseline(line)
   return checker( policy, password )
end


lines = open("input.txt") do input
   return readlines(input)
end

correct = @sync @distributed (+) for l in lines
   parse_and_check_password(l, check_password_part_1)
end

println("Part 1 Correct Passwords ", correct)

correct = @sync @distributed (+) for l in lines
   parse_and_check_password(l, check_password_part_2)
end

println("Part 2 Correct Passwords ", correct)
