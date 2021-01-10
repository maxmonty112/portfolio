require 'utils'
require 'open3'

class Commands
  @@u = Utils.new
  
  def new
    @@u.show_help if ARGV.length < 2
    file = "#{ARGV[1..-1].join('_')}.md"
    if file == "daily.md"
      puts "Use 'notes journal' to create daily note" 
      exit
    end
    for x in @@u.search_note_names(file)
      if x.split('/').pop() == file
        print "Note with that name already exists. Do you want to edit it (y/n)? "
        input = STDIN.gets
        exit if input == "n\n" or input == "\n"
        @@u.edit_file(x)
        @@u.move_file(x, Utils.mkdir_cur_date())
        exit
      end
    end
    path = @@u.mkdir_cur_date()
    @@u.edit_file("#{path}/#{file}")
  end

  def search
    if ARGV.length == 1
      @@u.show_help()
    elsif ARGV[1] == '-f'
      notes = @@u.search_note_names(ARGV[2..-1].join('_'))
      @@u.select_edit_move_file(notes)
    elsif ARGV[1] == '-t'
      notes = @@u.search_note_contents(ARGV[2..-1].join(' '))
      @@u.select_edit_move_file(notes)
    else 
      phrase = ARGV[1..-1]
      names = @@u.search_note_names(phrase.join('_'))
      mentions = @@u.search_note_contents(phrase.join(' '))
      @@u.select_edit_move_file(names + mentions)
    end
  end    

  def scratch
    @@u.edit_file(".scratch") 
  end

  def edit
    notes = @@u.search_note_names(ARGV[1..-1].join('_'))
    if notes.length == 1
      @@u.edit_file(notes[0])
      path = @@u.mkdir_cur_date()
      @@u.move_file(notes[0], path) 
    elsif notes.length < 1
      puts "\nFile not found. Use 'notes -l' to see all notes.\n\n"
    else 
      puts "Multiple notes found.\n----"
      @@u.select_edit_move_file(notes)
    end
  end

  def journal
    path = @@u.mkdir_cur_date()
    @@u.edit_file("#{path}/daily.md")
  end

  def list
    # TODO: change to $NOTESPATH

    o = Open3.capture2("find $HOME/documents/notes -type f")[0]
    files = o.split("\n")
    for file in files
      split_file = file.split('/')
      if split_file[-1][0] == '.'
      else
        puts split_file[-4..-1].join('/')
      end
    end
  end
end
