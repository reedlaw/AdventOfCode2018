require "string_scanner"

in = "initial state: #..#####.#.#.##....####..##.#.#.##.##.#####..####.#.##.....#..#.#.#...###..#..###.##.#..##.#.#.....#

.#.## => #
.###. => #
#..#. => .
...## => .
#.##. => #
....# => .
..##. => #
.##.. => .
##..# => .
.#..# => #
#.#.# => .
#.... => .
.#### => #
.##.# => .
..#.. => #
####. => #
#.#.. => .
.#... => .
###.# => .
..### => .
#..## => #
...#. => #
..... => .
###.. => #
#...# => .
..#.# => #
##... => #
##.## => .
##.#. => .
##### => .
.#.#. => #
#.### => #"

test = "initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #"

rules = Hash(String, String).new
state = ""
test.each_line do |l|
  if l =~ /^initial state: ([\.#]+)$/
    state = $1
  end
  next if l == ""
  if l =~ /^([\.#]{5}) => ([\.#]{1})$/
    rules[$1] = $2
  end
end

sum = 0
index = 0
2000000.times do |g|
  state = grow(state, rules, index)
end

state.chars.each_with_index do |c, i|
  pos = index + i
  sum += pos if c == '#'
end
p sum

def grow(state, rules, index)
  short = /^\.*([#.]*#)\.*$/.match(state).try &.[1]
  return "" if short.nil?
  index = state.index(short)
  state = short
  slices = state.chars.map_with_index do |c, i|
    if i < 5
      "."*(4-i) + state[0,i+1]
    elsif i == state.size
      state[i-4,1] + "." * 4
    else
      state[i-4, 5]
    end
  end
  4.times do |i|
    n = 4-i # 4
    slices << state[state.size-n,n] + "."*(i+1)
  end
  result = slices.map_with_index do |slice, i|
    if rules.has_key?(slice)
      rules[slice]
    else
      '.'
    end
  end.join
  result
end
