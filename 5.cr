str=File.read("5.in")
#str = "vVuyYJjUzzZPxX"

def reactable?(a, b)
  a.downcase == b.downcase &&
    (a.uppercase? && b.lowercase? || a.lowercase? && b.uppercase?)
end

def react(string)
  #p string
  last = '0'
  clipped = ""
  done = true
  string.each_char_with_index do |c, i|
    if reactable?(last, c)
      #p "reactable #{last}#{c}"
      if i < 2
        before = ""
      else
        before = string[0..i-2]
      end
      #p "before #{before}"
      if i == string.chars.size
        after = ""
      else
        after = string[i+1..-1]
      end
      #p "after #{after}"
      clipped = before + after
      done = false
      react(clipped)
      break
    end
    last = c
  end
  p string.chars.size if done
end

['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'].each do |letter|
  p letter
  subset = str.delete(letter)
  subset = subset.delete(letter.upcase)
  react(subset)
end
