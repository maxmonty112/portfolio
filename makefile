install:
	touch script.rb
	cat src/main.rb > script.rb
	cat src/constants.rb >> script.rb 
	cat src/help.rb >> script.rb
	cat src/helpers.rb >> script.rb
	cat src/commands.rb >> script.rb
	cp script.rb /usr/local/bin/notes
	chmod +x /usr/local/bin/notes
	ln -fs /usr/local/bin/notes /usr/local/bin/note	
	mkdir -p $(HOME)/documents/notes/stacks
	touch $(HOME)/documents/notes/stacks/.notestack
