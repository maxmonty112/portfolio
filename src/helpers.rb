def mkdir_cur_date
  path = $time.strftime("%Y/%m/%d")
  FileUtils.mkdir_p(path)
  return path
end

def edit_file(path)
  system("$EDITOR #{$notespath}/#{path}")
end

def move_file(file, loc)
  file_s = file.split('/')
  note = file_s.pop()
  loc_s = loc.split('/')
  system("mv #{$notespath}/#{file} #{$notespath}/#{loc}") if file_s != loc_s and note != 'daily.md'
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
    trimmed_paths.push(file[-4..-1].join('/')) if file[-1][0] != '.'
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
  exit if input == 'q'
  index = input.to_i
  if index > files.length-1 or index < 0
    puts "\nIndex out of range\n\n"
    exit
  end
  note_path = files[index]
  if note_path.split(':').length > 1
    note_path = note_path.split(':')
    note_path.pop()
    note_path = note_path[0..-1].join('/')
  end
  edit_file(note_path)
  path = mkdir_cur_date()
  move_file(note_path, path)
  puts "\n"
end
