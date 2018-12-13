f=File.open("7.in")
alias Dependencies = NamedTuple(visited: Bool, depends: Array(Char))
deps = Hash(Char, Dependencies).new
f.each_line do |l|
  l =~ /Step (.) must be finished before step (.) can begin./
  if deps.has_key?($2.chars[0])
    depends = deps[$2.chars[0]][:depends]
  else
    depends = [] of Char
  end
  depends << $1.chars[0]
  deps[$2.chars[0]] = { depends: depends, visited: false }

  if !deps.has_key?($1.chars[0])
    deps[$1.chars[0]] = { depends: [] of Char, visited: false }
  end
end

def walk(deps, available, final, ready)
  return final if deps.keys.size == available.size && ready.empty?
  new = find_ready(deps, available - ready)
  p "new #{new}"
  available = available + new
  ready = ready + new unless new.empty?
  first_alpha = ready.sort.shift
  final = final + first_alpha
  p "final #{final}"
  ready = ready.sort[1..-1]
  p "ready #{ready}"

  walk(deps, available, final, ready)
end

def find_ready(deps, available)
  deps.keys.sort.map do |k|
    h = deps[k]
    next if h[:visited] == true
    next unless h[:depends].all? { |c| available.index(c) }
    deps[k] = { visited: true, depends: [] of Char }
    k
  end.compact
end

p walk(deps, [] of Char, "", [] of Char)
