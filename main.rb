#!/usr/bin/env ruby

$LOAD_PATH << "#{ENV['NOTESCRIPT']}/lib"

require 'utils'
require 'commands'
require 'stack'

Kernel.trap("INT") { puts "\n"; exit; } 

if __FILE__ == $0
  c = Commands.new
  s = Stack.new
  u = Utils.new
  if ARGV.length == 0 or ARGV[0] == '-h' or ARGV[0] == '--help'
    u.show_help
  elsif ARGV[0] == "new"
    c.new
  elsif ARGV[0] == "search"
    c.search
  elsif ARGV[0] == "edit"
    c.edit
  elsif ARGV[0] == 'scratch'
    c.scratch
  elsif ARGV[0] == 'journal'
    c.journal
  elsif ARGV[0] == '-l' or ARGV[0] == '--list'
    c.list
  elsif ARGV[0] == 'stack'
    if ARGV.length == 1 or ARGV[1] == '-d' # display notestack
      s.default
    elsif ARGV[1] == 'pop' # pop off notestack
      s.pop_last_in
    elsif ARGV[1] == '-n' or ARGV[1] == '--new' # create new stack
      s.new
    elsif ARGV[1] == '-l' or ARGV == '--list' 
      s.list
    elsif ARGV[1] == '-a' or ARGV[1] == '--all'
      s.all
    else
      s.show
    end
  elsif ARGV[0] == 'push'
    s.push
  elsif ARGV[0] == 'pop'
    s.pop
  else
    show_help
  end
end
