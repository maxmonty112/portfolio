require 'utils'
require 'open3'

class Stack
  @@u = Utils.new
  @@default_stack = '.notestack'
  @@notespath = ENV['NOTESPATH']

  def default
    stack = @@u.load_stack(@@default_stack)
    if !stack.nil?
      for i in 0..stack.length-1
        puts "[#{i}] #{stack[i]}"
      end
    end
  end

  def pop_last_in
    if ARGV.length == 2 # pop last added
      stack = @@u.load_stack(@@default_stack)
      stack.pop()
      @@u.save_stack(stack, @@default_stack)
    elsif ARGV.length == 3 # pop by index
      stack = @@u.load_stack(@@default_stack)
      stack.delete_at(ARGV[1].to_i) 
      @@u.save_stack(stack, @@default_stack)
    end
  end

  def new
    if ARGV.length != 3
      puts "Error: stack name must be one word\n----"
      show_help
    else
      system("touch #{@@notespath}/stacks/.#{ARGV[2]}")
    end 
  end

  def list
    o = Open3.capture2("find #{@@notespath}/stacks -type f")[0]
    files = o.split("\n")
    for file in files
      filename = file.split('/')[-1]
      if filename == @@default_stack
        puts "default"
      else 
        puts "#{filename[1..-1]}"
      end
    end 
  end

  def all
    o = Open3.capture2("find #{@@notespath}/stacks -type f")[0]
    files = o.split("\n")
    for file in files
      filename = file.split('/')[-1]
      stack = @@u.load_stack(filename)
      if filename == @@default_stack
        puts "*default*"
      else 
        puts "*#{filename[1..-1]}*"
      end
      if !stack.nil?
        for i in 0..stack.length-1
          puts "[#{i}] #{stack[i]}"
        end
      end
      puts "----"
    end
  end

  def show
    stack = @@u.load_stack(".#{ARGV[1]}")
    if !stack.nil?
      for i in 0..stack.length-1
        puts "[#{i}] #{stack[i]}"
      end
    end
  end

  def pop
    if ARGV[1] == '-d'
      if ARGV.length == 2 # pop last added
        stack = @@u.load_stack(@@default_stack)
        stack.pop()
        @@u.save_stack(stack, @@default_stack)
      elsif ARGV.length == 3 # pop by index
        stack = @@u.load_stack(@@default_stack)
        stack.delete_at(ARGV[2].to_i) 
        @@u.save_stack(stack, @@default_stack)
      end
    else
      filename = ".#{ARGV[1]}"
      stack = @@u.load_stack(filename)
      if ARGV.length == 2
        stack.pop()
        @@u.save_stack(stack, filename)
      else
        stack.delete_at(ARGV[2].to_i)
        @@u.save_stack(stack, filename)
      end 
    end
  end

  def push
    if ARGV.length == 1
      puts "must push something"
    elsif ARGV[1] == '-d'
      if ARGV.length < 3
        puts "most push something"
      else
        stack = @@u.load_stack(@@default_stack)
        task =  ARGV[2..-1].join(' ')
        if stack.nil?
          stack = [task]
        else
          stack.push(ARGV[2..-1].join(' '))
        end
        @@u.save_stack(stack, @@default_stack)
      end
    else
      filename = ".#{ARGV[1]}"
      o = Open3.capture2("find #{@@notespath}/stacks -type f -name #{filename}")[0]
      files = o.split("\n")
      if files.length() == 1
        stack = @@u.load_stack(filename)
        task =  ARGV[2..-1].join(' ')
        if stack.nil?
          stack = [task]
        else
          stack.push(ARGV[2..-1].join(' '))
        end
        @@u.save_stack(stack, filename)
      elsif files.length() < 1
        puts "stack not found"
      elsif files.length() > 1
        count = 0
        for file in files
          # TODO trim output
          puts "[#{count}]  #{file}\n"
          count = count + 1
        end
        print "Choose an index: "
        index = STDIN.gets.to_i
      end
    end
  end

  def remove
    if ARGV.length != 3
      @@u.show_help
    end 
    system("rm $NOTESPATH/stacks/.#{ARGV[2]}")
  end
end
