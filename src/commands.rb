# help
if ARGV.length == 0 or ARGV[0] == '-h' or ARGV[0] == '--help'
  show_help()
end

# new note
if ARGV[0] == "new"
  if ARGV.length < 2
    show_help()
  end
  # TODO: if note name exists, give option to edit old or change name of new note
  name = "#{ARGV[1..-1].join('_')}.md"
  if name == "daily.md"
    puts "Use 'notes journal' to create daily note" 
    exit
  end
  for x in search_note_names(name)
    if x.split('/').pop() == name
      print "Note with that name already exists. Do you want to edit it (y/n)? "
      input = STDIN.gets
      exit if input == "n\n" or input == "\n"
      edit_file(x)
      move_file(x, mkdir_cur_date())
      exit
    end
  end
  path = mkdir_cur_date()
  edit_file("#{path}/#{name}")
  
# search
elsif ARGV[0] == "search"
  if ARGV.length == 1
    show_help()
  elsif ARGV[1] == '-f'
    notes = search_note_names(ARGV[2..-1].join('_'))
    select_edit_move_file(notes)
  elsif ARGV[1] == '-t'
    notes = search_note_contents(ARGV[2..-1].join(' '))
    select_edit_move_file(notes)
  else 
    phrase = ARGV[1..-1]
    names = search_note_names(phrase.join('_'))
    mentions = search_note_contents(phrase.join(' '))
    select_edit_move_file(names + mentions)
  end
  
# edit note
elsif ARGV[0] == "edit"
  notes = search_note_names(ARGV[1..-1].join('_'))
  if notes.length == 1
    edit_file(notes[0])
    path = mkdir_cur_date()
    move_file(notes[0], path) 
  elsif notes.length < 1
    puts "\nFile not found. Use 'notes -l' to see all notes.\n\n"
  else 
    puts "Multiple notes found.\n----"
    select_edit_move_file(notes)
  end

# scratch
elsif ARGV[0] == 'scratch'
  edit_file("#{$notespath}/.scratch")

# journal
elsif ARGV[0] == 'journal'
  path = mkdir_cur_date()
  edit_file("#{path}/daily.md")

# all notes
elsif ARGV[0] == '-l' or ARGV[0] == '--list'
  o = Open3.capture2("find $HOME/documents/notes -type f")[0]
  files = o.split("\n")
  for file in files
    split_file = file.split('/')
    if split_file[-1][0] == '.'
    else
      puts split_file[-4..-1].join('/')
    end
  end

# stack
elsif ARGV[0] == 'stack'
  if ARGV.length == 1 or ARGV[1] == '-d' # display notestack
    stack = load_stack($default_stack)
    if !stack.nil?
      for i in 0..stack.length-1
        puts "[#{i}] #{stack[i]}"
      end
    end
  elsif ARGV[1] == 'pop' # pop off notestack
    if ARGV.length == 2 # pop last added
      stack = load_stack($default_stack)
      stack.pop()
      save_stack(stack, $default_stack)
    elsif ARGV.length == 3 # pop by index
      stack = load_stack($default_stack)
      stack.delete_at(ARGV[1].to_i) 
      save_stack(stack, $default_stack)
    end
  elsif ARGV[1] == '-n' or ARGV[1] == '--new' # create new stack
    if ARGV.length != 3
      puts "stack name must be one word"
    else
      system("touch #{$notespath}/stacks/.#{ARGV[2]}")
    end 
  elsif ARGV[1] == '-l' or ARGV == '--list' 
    o = Open3.capture2("find #{$notespath}/stacks -type f")[0]
    files = o.split("\n")
    for file in files
      filename = file.split('/')[-1]
      if filename == $default_stack
        puts "default"
      else 
        puts "#{filename[1..-1]}"
      end
    end 
  elsif ARGV[1] == '-a' or ARGV[1] == '--all'
    o = Open3.capture2("find #{$notespath}/stacks -type f")[0]
    files = o.split("\n")
    puts "\n"
    for file in files
      filename = file.split('/')[-1]
      stack = load_stack(filename)
      if filename == $default_stack
        puts "*default*"
      else 
        puts "*#{filename[1..-1]}*"
      end
      if !stack.nil?
        for i in 0..stack.length-1
          puts "[#{i}] #{stack[i]}"
        end
        puts "\n"
      end
    end
  else
    stack = load_stack(".#{ARGV[1]}")
    if !stack.nil?
      for i in 0..stack.length-1
        puts "[#{i}] #{stack[i]}"
      end
    end
  end

# push onto notestack  
elsif ARGV[0] == 'push'
  if ARGV.length == 1
    puts "must push something"
  elsif ARGV[1] == '-d'
    if ARGV.length < 3
      puts "most push something"
    else
      stack = load_stack($default_stack)
      task =  ARGV[2..-1].join(' ')
      if stack.nil?
        stack = [task]
      else
        stack.push(ARGV[2..-1].join(' '))
      end
      save_stack(stack, $default_stack)
    end
  else
    filename = ".#{ARGV[1]}"
    o = Open3.capture2("find #{$notespath}/stacks -type f -name #{filename}")[0]
    files = o.split("\n")
    if files.length() == 1
      stack = load_stack(filename)
      task =  ARGV[2..-1].join(' ')
      if stack.nil?
        stack = [task]
      else
        stack.push(ARGV[2..-1].join(' '))
      end
      save_stack(stack, filename)
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
  
elsif ARGV[0] == 'pop'
  if ARGV[1] == '-d'
    if ARGV.length == 2 # pop last added
      stack = load_stack($default_stack)
      stack.pop()
      save_stack(stack, $default_stack)
    elsif ARGV.length == 3 # pop by index
      stack = load_stack($default_stack)
      stack.delete_at(ARGV[2].to_i) 
      save_stack(stack, $default_stack)
    end
  else
    filename = ".#{ARGV[1]}"
    stack = load_stack(filename)
    if ARGV.length == 2
      stack.pop()
      save_stack(stack, filename)
    else
      stack.delete_at(ARGV[2].to_i)
      save_stack(stack, filename)
    end 
  end
else
  show_help()
end
