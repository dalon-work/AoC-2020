struct MyInt
   val::Int64
end

import Base.:+
+(a::MyInt, b::MyInt) = MyInt(a.val + b.val)
-(a::MyInt, b::MyInt) = MyInt(a.val * b.val)

sum = 0
for line in readlines("input.txt")
   line = replace(line, '*' => '-')
   line = replace(line, r"(\d+)" => s"MyInt(\1)")
   a = eval(Meta.parse(line))
   global sum = sum + a.val
end

println(sum)
