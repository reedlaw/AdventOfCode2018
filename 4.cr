f = File.open("4.in")
stamps = {} of Time => String
f.each_line do |l|
  l =~ /\[(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})\] (.+)/
  t = Time.new($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i)
  stamps[t] = $6
end
entries = {} of String => Array(String)
stamps.keys.sort.each do |k|
  entries[k.to_s("%D")] ||= [] of String
  entries[k.to_s("%D")] << k.to_s("%M") + stamps[k]  
end
asleep = {} of Int32 => Array(Int32)
current = 0
sleep_time = 0
awake_time = 0
# 1987
entries.keys.each do |e|
  entries[e].each do |j|
    if j =~ /Guard #(\d+) begins shift/
      p "#{j} on #{e}"
      current = $1.to_i
      asleep[current] ||= Array.new(60) { |a| a = 0 }
    elsif j =~ /(\d+)falls asleep/
      p "Guard ##{current} falls asleep at #{$1}"
      sleep_time = $1.to_i
    elsif j =~ /(\d+)wakes up/
      p "Guard ##{current} wakes up at #{$1}"
      awake_time = $1.to_i
      while sleep_time < awake_time
        asleep[current][sleep_time] += 1
        sleep_time += 1
      end
    end
  end
end
asleep.each do |k, v|
  p "#{v} #{k}"
end
