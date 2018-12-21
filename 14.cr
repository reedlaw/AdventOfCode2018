elf1 = 0
elf2 = 1
recipes = [3,7]
#last_6 = [1,  5,  8,  9,  1,  6] 
last_6 = [9, 3, 9, 6, 0, 1]
until recipes.size > 6 && last_6 == recipes[-6..-1]
  sum = recipes[elf1] + recipes[elf2]
  new_recipes = sum.to_s.chars.map { |c| c.to_i }
  recipes = recipes + new_recipes
  new_elf1 = (elf1 + (1 + recipes[elf1])) % recipes.size
  new_elf2 = (elf2 + (1 + recipes[elf2])) % recipes.size
  elf1 = new_elf1
  elf2 = new_elf2
  #elf1 = elf1 % recipes.size
  #elf1 = elf2 % recipes.size  
  #show(recipes, elf1, elf2)
  p recipes.size if recipes.size % 1000 == 0
end
p (recipes.size - 6)

def show(recipes, elf1, elf2)
  recipes.map_with_index do |r, i|
    if elf1 == i
      print '(' + r.to_s + ')'
    elsif elf2 == i
      print '[' + r.to_s + ']'
    else
      print ' ' + r.to_s + ' '
    end
  end
  print '\n'
end
