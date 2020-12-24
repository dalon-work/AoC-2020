rules, msgs = split(read("input.txt",String),"\n\n")
rule_dict = Dict( Pair(split(r,": ")...) for r in split(rules,'\n') )

function build(num)
   group = String("(?:")
   for t in split(rule_dict[num])
      if t[1] == '"'
         group = group * t[2]
      elseif t[1] in '0':'9'
         group = group * build(t)
      elseif t[1] == '|'
         group = group * '|'
      end
   end
   group * ')'
end

println( sum( occursin(Regex('^' * build("0") * '$'), msg) for msg in split(msgs,'\n') ) )
