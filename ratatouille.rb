#!/usr/bin/env ruby

def solve(needs, all_packages)
  all_packages.each_with_index do |packages, i|
    all_packages[i] = packages.sort.reverse
  end

  min_grams = needs.map{ |n| n*0.9 }
  max_serving = all_packages.each_with_index.map do |packages, i|
    packages.map{ |p| (p/min_grams[i]).to_i }.max
  end.min
  return 0 if max_serving == 0

  total_serving = 0

  all_ranges = (1..max_serving).map{ |x| needs.map{ |n| (n*x*0.9..n*x*1.1) } }.reverse
  all_ranges.each do |ranges|
    all_good = all_packages.each_with_index.map do |packages, i|
      packages.select{ |p| ranges[i].include?(p) }
    end
    serving = all_good.map { |x| x.count }.min
    next if serving == 0
    all_packages.each_with_index do |packages, i|
      good = all_good[i][0, serving]
      good.each do |x|
        packages.delete_at packages.find_index(x)
      end
      all_packages[i] = packages
    end
    total_serving += serving
  end
  total_serving
end


case_count = gets.chomp.to_i
case_count.times { |cc|
  n, p = gets.chomp.split(' ').map(&:to_i)
  needs = gets.chomp.split(' ').map(&:to_f)
  all_packages = n.times.map do |i|
    gets.chomp.split(' ').map(&:to_f)
  end

  ans = solve(needs, all_packages)
  puts "Case ##{cc+1}: #{ans}"
}
