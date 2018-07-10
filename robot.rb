require 'optparse'
require_relative 'app/robot'

options = {dimensions: [5, 5]}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: robot.rb [options]"
  opts.on("--dimensions D", String, "dimensions of table: X,Y") do |d|
    options[:dimensions] = d.split(',').map(&:to_i)
  end

  opts.on("--commands COMMANDS", String, "a series of commands") do |cmds|
    options[:cmds] = cmds.split(',').map(&:downcase).map(&:strip)
  end
end.parse!

exit unless options[:cmds]

robot = Robot.new(Table.new(*options[:dimensions]))
options[:cmds].each do |c|
  puts "CMD: #{c}"
  begin
    if /place/ =~ c
      c = c.split
      robot.place_cmd(c[1].to_i, c[2].to_i, c[3].to_sym)
    else
      r = robot.send("#{c}_cmd")
      puts "RPT: #{r}" if c == 'report'
    end
  rescue RuntimeError => e
    puts "ERR: #{e.message}"
  rescue
    puts "SHOULD NOT be here"
  end
end
