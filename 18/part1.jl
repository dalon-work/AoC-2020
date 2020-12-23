import Base.:+
struct MyInt val::Int64 end
+(a::MyInt, b::MyInt) = MyInt(a.val + b.val)
-(a::MyInt, b::MyInt) = MyInt(a.val * b.val)
println( sum( [eval(Meta.parse(replace(replace(line, '*' => '-'),r"(\d+)" => s"MyInt(\1)"))).val for line in readlines("input.txt") ] ) )
