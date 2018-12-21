paths = Hash(Array(Int32), Char).new
y = 0
max_x = 0
File.read("13part2.test").each_line do |l|
  x = 0
  l.each_char do |c|
    max_x = x if x > max_x
    paths[[x, y]] = c
    x += 1
  end
  y += 1
end
max_y = y
max_x += 1

carts = Hash(Array(Int32), Cart).new
max_y.times do |y|
  max_x.times do |x|
    c = paths[[x, y]]
    if ['<', '>', '^', 'v'].includes? c
      carts[[x, y]] = Cart.new(paths[[x, y]], x, y)
      paths[[x, y]] = '-' if ['<', '>'].includes? c
      paths[[x, y]] = '|' if ['^', 'v'].includes? c
    end
  end
end

last_one = false
i = 0
while !last_one
  i += 1

  new_carts = Hash(Array(Int32), Cart).new

  max_y.times do |y|
    max_x.times do |x|
      if carts.has_key?([x, y])
        cart = carts[[x, y]]
        if new_carts.has_key?([cart.x, cart.y])
          new_carts.delete([cart.x, cart.y])
        else
          cart.traverse(paths[[x, y]])
          if new_carts.has_key?([cart.x, cart.y])
            new_carts.delete([cart.x, cart.y])
          else
            new_carts[[cart.x, cart.y]] = cart
          end
        end
      end
    end
  end
  # show(carts, paths, max_x, max_y)
  if new_carts.size == 1
    cart = new_carts[new_carts.keys[0]]
    p "last remaining cart is at #{cart.x}, #{cart.y}"
    last_one = true
  end
  p new_carts.size
  carts = new_carts
end

def show(carts, paths, max_x, max_y)
  print "   "
  max_x.times do |x|
    print x / 100
  end
  print '\n'
  print "   "
  max_x.times do |x|
    print x % 100 / 10
  end
  print '\n'
  print "   "
  max_x.times do |x|
    print x % 10
  end
  print '\n'
  max_y.times do |y|
    print y.to_s.rjust(3)
    max_x.times do |x|
      if carts.has_key?([x, y])
        c = carts[[x, y]].c
      else
        c = paths[[x, y]]
      end
      print c
    end
    print '\n'
  end      
end

class Cart
  property c : Char
  property x : Int32
  property y : Int32
  property next_turn : Symbol

  def initialize(c, x, y)
    @c = c
    @x = x
    @y = y
    @next_turn = :left
    @last_path = ' '
  end

  def traverse(path)
    if path == '+' # intersections
      turn
      @x += 1 if @c == '>'
      @x -= 1 if @c == '<'
      @y -= 1 if @c == '^'
      @y += 1 if @c == 'v'
    else
      if !['\\', '/'].includes?(@last_path)
        if @c == '>'
          @c = if path == '\\'
                 'v'
               elsif path == '/'
                 '^'
               else
                 @c
               end
        elsif @c == '<'
          @c = if path == '\\'
                 '^'
               elsif path == '/'
                 'v'
               else
                 @c
               end
        elsif @c == '^'
          @c = if path == '\\'
                 '<'
               elsif path == '/'
                 '>'
               else
                 @c
               end
        elsif @c == 'v'
          @c = if path == '\\'
                 '>'
               elsif path == '/'
                 '<'
               else
                 @c
               end
        end
      end
      @x += 1 if @c == '>'
      @x -= 1 if @c == '<'
      @y -= 1 if @c == '^'
      @y += 1 if @c == 'v'
    end
    @last_path = path
  end

  def turn
    if @next_turn == :left
      @c = case @c
           when '<'
             'v'
           when 'v'
             '>'
           when '>'
             '^'
           else
             '<'
           end
      @next_turn = :straight
    elsif @next_turn == :right
      @c = case @c
           when '<'
             '^'
           when 'v'
             '<'
           when '>'
             'v'
           else
             '>'
           end
      @next_turn = :left
    else
      @next_turn = :right
    end
  end
end

