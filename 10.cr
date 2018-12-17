require "stumpy_png"
include StumpyPNG

test_input = "position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>"

scale = 500
zoom = 1
adjust = 50000
max_x = 0
max_y = 0
min_x = 0
min_y = 0
positions = [] of Array(Int32)
velocities = [] of Array(Int32)
File.read("10.in").each_line do |l|
  l =~ /^position=<\s?(\-?[0-9]+),\s+(\-?[0-9]+)> velocity=<\s?(\-?[0-9]+),\s+(\-?[0-9]+)>$/
  pos_x = $1.to_i / zoom
  max_x = [pos_x, max_x].max
  min_x = [pos_x, min_x].min
  pos_y = $2.to_i / zoom
  max_y = [pos_y, max_y].max
  min_y = [pos_y, min_y].min  
  positions << [pos_x, pos_y]
  vel_x = $3.to_i
  vel_y = $4.to_i
  velocities << [vel_x, vel_y]
end
xs = (min_x - max_x).abs + 1
ys = (min_y - max_y).abs + 1
view_x = xs/2 - scale - adjust
view_w = xs/2 + scale - adjust
view_y = ys/2 - scale - adjust
view_h = ys/2 + scale - adjust
15000.times do |seconds|
  puts "After #{seconds} seconds"
  positions.map_with_index! do |pos, i|
    x = pos[0] + velocities[i][0]
    y = pos[1] + velocities[i][1]
    pos = [x, y]
  end
  next unless seconds > 10000 && seconds < 15000
  p positions[0]
  p positions[-1]  
  p scale*2 + view_x
  p scale*2 + view_y
  canvas = Canvas.new(scale*2, scale*2)
  (scale*2).times do |y|
    (scale*2).times do |x|
      if positions.includes?([x+view_x, y+view_y])
        color = RGBA.from_rgb_n(255, 0, 0, 8)
      else
        color = RGBA.from_rgb_n(25, 200, 123, 8)
      end
      canvas[x, y] = color
    end
  end
  StumpyPNG.write(canvas, "second_#{seconds}.png")
end
