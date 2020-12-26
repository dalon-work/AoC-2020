import regex
rules, msgs = open("input.txt").read().split("\n\n")
rule_dict = dict( tuple(r.split(": ")) for r in rules.split('\n') )

def build(num):
    if num == "8":
        return "(?:" + build("42") + ")+"
    elif num == "11":
        return "(?P<one>" + build("42") + build("31") + "|" + build("42") + "(?P>one)" + build("31") + ")"
    group = "(?:"
    for t in rule_dict[num].split():
        if t[0] == '"':
            group = group + t[1]
        elif t[0] in ["0","1","2","3","4","5","6","7","8","9"]:
            group = group + build(t)
        elif t[0] == '|':
            group = group + '|'
    return group + ')'

zero_re = regex.compile("^" + build("0") + "$")

s = 0
for msg in msgs.split('\n'):
    m = zero_re.match(msg)
    if not (m is None):
        s += 1

print(s)

