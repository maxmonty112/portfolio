def mkdir_cur_date
  path = "#{$notespath}/#{$time.strftime("%Y/%m/%d")}"
  FileUtils.mkdir_p(path)
  return path
end

def edit_file(path)
  system("$EDITOR #{path}")
end

def move_file(file, loc)
  file_s = file.split('/')
  file_s.pop()
  loc_s = loc.split('/')
  if file_s != loc_s
    system("mv #{file} #{loc}")
  end
end

def load_stack(stack_name)
  return JSON.load(File.open("#{$notespath}/stacks/#{stack_name}", 'r+'))
end
  
def save_stack(stack, stack_name)
  return File.write("#{$notespath}/stacks/#{stack_name}", JSON.dump(stack))
end

def trim_paths(paths)
  split = paths.split("\n")
  trimmed_paths = []
  for x in split
    file = x.split('/')
    if file[-1][0] == '.'
      # ignore hidden files
    else
      trimmed_paths.push(file[-4..-1].join('/'))
    end
  end
  return trimmed_paths
end

# search note names
def search_note_names(name)
  notes = Open3.capture2("find #{$notespath} -type f -name \"*#{name}*\"")[0]
  return trim_paths(notes) 
end

def search_note_contents(phrase)
  notes = Open3.capture2("grep -ir '#{phrase}' #{$notespath}*")[0]
  return trim_paths(notes) 
end

def select_edit_move_file(files)
  count = 0
  for file in files 
    puts "[#{count}]  #{file}"
    count = count + 1
  end
  print "\nChoose an index to edit (or 'q' to quit): "
  input = STDIN.gets.chomp 
  if input.to_s == 'q'
    puts "\n"
    exit
  end
  index = input.to_i
  if index > files.length-1 or index < 0
    puts "\nIndex out of range\n\n"
    exit
  end
  file_path = "#{$notespath}/#{files[index]}"
  edit_file(file_path)
  path = mkdir_cur_date()
  move_file(file_path, path)
  puts "\n"
end
