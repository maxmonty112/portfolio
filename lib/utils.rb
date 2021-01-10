require 'fileutils'
require 'json'

class Utils
  @@notespath = ENV['NOTESPATH']
  @@time = Time.new

  def show_help
    puts "valid commands:"
    puts "\tnew <title>"
    puts "\tsearch [-f | -t] <title>"
    exit
  end  

  def mkdir_cur_date
    p = @@time.strftime("%Y/%m/%d")
    FileUtils.mkdir_p("#{@@notespath}/#{p}")
    return p
  end

  def edit_file(f)
    system("$EDITOR #{@@notespath}/#{f}")
  end

  def move_file(f, l)
    if @@time.strftime("%Y/%m/%d") != l and f.split('/').pop() != 'daily.md'
      FileUtils.mv "#{@@notespath}/#{f}", "#{@@notespath}/#{l}"
    end
  end

  def load_stack(s)
    return JSON.load(File.open("#{@@notespath}/stacks/#{s}", 'r+'))
  end
    
  def save_stack(s, n)
    return File.write("#{@@notespath}/stacks/#{n}", JSON.dump(s))
  end

  def trim(p)
    t = []
    for x in p.split("\n")
      y = x.split('/')
      t.push(y[-4..-1].join('/')) if y[-1][0] != '.'
    end
    return t
  end

  def search_note_names(n)
    return trim(Open3.capture2("find #{@@notespath} -type f -name \"*#{n}*\"")[0])
  end

  def search_note_contents(p)
    return trim(Open3.capture2("grep -ir '#{p}' #{@@notespath}*")[0])
  end

  def select_edit_move_file(f)
    c = 0
    for x in f 
      puts "[#{c}]  #{x}"
      c = c + 1
    end
    print "----\nChoose an index to edit (or 'q' to quit): "
    input = STDIN.gets
    exit if input == "q\n" or input == "\n"
    i = input.to_i
    if i > f.length-1 or i < 0 or i == ''
      puts "\nIndex out of range\n\n"
      exit
    end
    p = f[i]
    if p.split(':').length > 1
      p = p.split(':')
      p.pop()
      p = p[0..-1].join('/')
    end
    edit_file(p)
    move_file(p, mkdir_cur_date())
  end
end
