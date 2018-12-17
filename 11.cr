SERIAL_NUMBER = 5093

def power_level(x, y)
  rack_id = x + 10
  power_level = rack_id * y
  increased_power_level = power_level + SERIAL_NUMBER
  total_power_level = increased_power_level * rack_id
  hundreds_digit = total_power_level % 10 % 10
  hundreds_digit - 5
end

largest_square = 0
largest_square_coords = [0, 0]
300.times do |i|
  y = i + 1
  300.times do |j|
    x = j + 1
    next if x > 297 || y > 297
    square_size = power_level(x, y) + power_level(x + 1, y) + power_level(x + 2, y)
    square_size += power_level(x, y + 1) + power_level(x + 1, y + 1) + power_level(x + 2, y + 1)
    square_size += power_level(x, y + 2) + power_level(x + 1, y + 2) + power_level(x + 2, y + 2)
    if square_size > largest_square
      largest_square = square_size
      largest_square_coords = [x, y]
    end
  end
end

p largest_square
p largest_square_coords
