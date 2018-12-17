SERIAL_NUMBER = 18

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
largest_size = 1
300.times do |i|
  y = i + 1
  300.times do |j|
    x = j + 1
    # 300.times do |s| # 300 sizes
    s = 15
      size = s + 1
      next if x > 300 - s || y > 300 - s
      square_size = 0
      size.times do |m| # 3
        size.times do |n| # 3
          level = power_level((x + n), (y + m))
          if level > 0
            print "#"
          else
            print "."
          end          
          square_size += level
        end
        print "\n"
      end
      p "square_size #{square_size}"
      print "\n"
      if square_size > largest_square
        largest_square = square_size
        largest_square_coords = [x, y]
        largest_size = size
      end
    #end
  end
end

p largest_square
p largest_square_coords
p largest_size
