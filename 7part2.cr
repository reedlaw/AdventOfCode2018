f=File.open("7.test")
alias Dependencies = NamedTuple(visited: Bool, depends: Array(Char))
alias Worker = NamedTuple(job: Char, timer: Int32)
MAX_WORKERS = 2
workers = [] of Worker
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

def walk(workers, deps, available, final, ready)
  return final if deps.keys.size == available.size && ready.empty?
  new = find_ready(deps, available - ready)
  p "new #{new}"
  available = available + new
  ready = ready + new unless new.empty?
  first_alpha = ready.sort.shift
  assign_job(workers, first_alpha)
  ready = ready.sort[1..-1]
  p workers
  unless workers.size < MAX_WORKERS
    finished = [] of Char
    while finished.empty?
      p workers
      finished = tick(workers)
    end
    p finished
    finished.each do |c|
      final += c.to_s
    end
  end
  walk(workers, deps, available, final, ready)
end

def assign_job(workers, job)
  timer = job.ord - 64
  workers << { job: job, timer: timer }
end
             
def tick(workers)
  workers = workers.map do |worker|
    timer = worker[:timer]
    timer = timer -1
    p timer
    { job: worker[:job], timer: timer }
  end
  if finished = workers.index { |w| w[:timer] == 0 }
    finished_chars = workers.select { |w| w[:timer] == 0 }.map { |w| w[:job] }
    workers.delete_at(finished)
    return finished_chars
  end
  [] of Char
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

p walk(workers, deps, [] of Char, "", [] of Char)
