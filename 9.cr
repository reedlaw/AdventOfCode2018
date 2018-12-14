# 7 players; last marble is worth 25 points: high score is 32
# 10 players; last marble is worth 1618 points: high score is 8317
# 13 players; last marble is worth 7999 points: high score is 146373
# 17 players; last marble is worth 1104 points: high score is 2764
# 21 players; last marble is worth 6111 points: high score is 54718
# 30 players; last marble is worth 5807 points: high score is 37305

# 425 players; last marble is worth 70848 points

PLAYER_COUNT = 425
marbles = [0]
current_player = 0
current_marble_index = 1
scores = Array.new(PLAYER_COUNT, 0_i64)
7084800.times do |marble|
  next if marble == 0
  puts marble/10000 if marble % 10000 == 0
  if marble % 23 == 0
    current_marble_index -= 7
    if current_marble_index < 0
      current_marble_index = current_marble_index % marbles.size
    end
    scores[current_player] += marble + marbles[current_marble_index]
    marbles.delete_at(current_marble_index)
  else # determine marble position
    if marbles.size == 1
      marbles << marble
    else
      current_marble_index += 2
      if current_marble_index > marbles.size
        current_marble_index = current_marble_index % marbles.size
      end
      marbles.insert(current_marble_index, marble)
    end
  end
  # p "[#{current_player}] #{marbles.join(" ")}"
  if current_player < PLAYER_COUNT - 1
    current_player += 1
  else
    current_player = 0
  end
end
p scores.sort[-1]
