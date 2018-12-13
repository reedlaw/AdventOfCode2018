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
    row.push within_region?(x, y, cords)
  end
  locations << row
end

total = 0
h.times do |y|
  w.times do |x|
    total += 1 if locations[y][x] == 0
  end
end

p total

def within_region?(x, y, cords)
  distances = [] of Int32
  cords.each do |cord|
    distances << get_distance(x, y, cord)
  end
  distances.reduce { |a, b| a + b } < 10000 ? 0 : -1
end

def get_distance(x, y, cord)
  (x - cord[0]).abs + (y - cord[1]).abs
end
