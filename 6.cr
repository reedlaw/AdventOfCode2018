f=File.open("6.in")
cords = [] of Array(Int32)
xs = [] of Int32
ys = [] of Int32
f.each_line do |l|
  x, y = l.split(", ")
  pair = [x.to_i, y.to_i]
  xs << x.to_i
  ys << y.to_i
  cords << pair
end

w = xs.sort.last + 1
h = ys.sort.last + 1

locations = [] of Array(Int32)

h.times do |y|
  row = [] of Int32
  w.times do |x|
    if i = cords.index([x, y])
      row.push i
    else
      row.push get_closest(x, y, cords)
    end
  end
  locations << row
end

# h.times do |y|
#   puts locations[y][0..-1]
# end

infinites = Set.new [-1]
h.times do |y|
  w.times do |x|
    infinites.add(locations[y][x]) if (y == 0 || y == h-1) || (x == 0 || x == w-1)
  end
end

h.times do |y|
  infinites.each do |i|
    locations[y].delete(i)
  end
end

sizes = {} of Int32 => Int32
locations.flatten.uniq.each do |u|
  sizes[locations.flatten.count(u)] = u
end

p sizes.keys.sort.last

def get_closest(x, y, cords)
  distances = [] of Int32
  cords.each do |cord|
    distances << get_distance(x, y, cord)
  end
  closest = distances.sort.first
  if distances.select { |d| d == closest }.size > 1
    -1
  else
    distances.index(closest).not_nil!
  end
end

def get_distance(x, y, cord)
  (x - cord[0]).abs + (y - cord[1]).abs
end
