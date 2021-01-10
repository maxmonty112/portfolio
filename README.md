# Notes

A minamlist command-line interface for note taking and organization, journaling, and task-tracking/managment written in ruby inspired by (and emulative of) Max Hodak's note-taking [system](https://github.com/maxhodak/notes) written in python. 

# Installation
1. Clone repo

2. Add the following to your `.bash_profile`: 

```
export NOTESPATH="/path/to/where/you/want/notes/saved"
export NOTESCRIPT="/path/to/where/you/cloned/this/repo"
```
    
3. Run the following commands inside repo:

```
make install
bundle install
```
    
# Basic Usage

```
notes new <note> -- create new note
notes search [-ft] <phrase> --- search notes by name and or contents
notes scratch --- open scratch pad
notes edit <note> --- edit existing note
notes journal --- create/edit daily journal entry
notes [-h] --- show this message
notes [-l | --list] --- show all notes
notes stack [-adlnr] <title> --- create, delete, list, display stacks
notes push [-d] <stack> --- push to stack
notes pop [-d] <stack> <index> --- pop off stack
```
### Create notes

```
$ notes new my brilliant idea
```

This will create a new note `$NOTESPATH/year/month/date/my_brilliant_idea.md` and open your default editor.

### Edit notes

```
$ notes edit idea
``` 

If there is only one matching note, it will open it in your default editor. Otherwise, you will see a message like this:

```
Multiple notes found.
----
[0]  2021/01/10/my_brilliant_idea.md
[1]  2020/12/25/ideas.md
----
Choose an index to edit (or 'q' to quit): 
```

When you edit a note, it moves it to the directory corresponding to the current date. 

### Search notes

```
$ notes search idea
[0]  2021/01/10/my_brilliant_idea.md
[1]  2020/12/25/ideas.md
[2]  2021/01/07/books.md:- **Essays**, **Ideas and Opinions**, Albert Einstein
[3]  2021/01/07/books.md:*Philosphers that prevade modern thinking and contributed to my own ideas:*
[4]  2021/01/09/dhamma_letter_13.md:Dhamma letter # 13 need idea to understand. Too theoretical now. 
----
Choose an index to edit (or 'q' to quit):
```
This will show all notes containing 'idea' in their name and all notes in which 'idea' is written.

Use `-f` to search only note names:

```
$ notes search -f idea
[0]  2021/01/10/my_brilliant_idea.md
[1]  2020/12/25/ideas.md
----
Choose an index to edit (or 'q' to quit):
```

Use `-t` to search for mentions only: 

```
$ notes search -t idea
[0]  2021/01/07/books.md:- **Essays**, **Ideas and Opinions**, Albert Einstein
[1]  2021/01/07/books.md:*Philosphers that prevade modern thinking and contributed to my own ideas:*
[2]  2021/01/09/dhamma_letter_13.md:Dhamma letter # 13 need idea to understand. Too theoretical now. 
----
Choose an index to edit (or 'q' to quit): 
```

### Scratch pad

```
$ notes scratch
```

Opens up a hidden file on $NOTESPATH to use as a scratch pad

**List all notes**

```
$ notes -l
2021/01/04/daily.md
2021/01/04/dhamma_letter_11.md
2021/01/10/my_brilliant_idea.md
2021/01/07/books.md
2021/01/09/workouts.md
2021/01/09/dhamma_letter_12.md
2021/01/09/dhamma_letter_13.md
2021/01/09/documentaries.md
2021/01/08/daily.md
2021/01/08/stretching.md
2020/12/25/ideas.md
```

### Show help 

```
$ notes -h
```

# Journal

```
$ notes journal
```

This will create a note `$NOTESPATH/year/month/date/daily.md` (or edit if already created for the current day). You can edit previous daily notes and they will note be moved to a new directory. 

# Stack

This tool allows you to maintain numerous stacks to track various work flows. 

### Default stack

`notes` comes with a default stack. To push to the default stack, run the following command:

```
$ notes push -d go for a run
```

And then you can display the default stack with:

```
$ notes stack
[0] read
[1] stretch
[2] go for a run
```

To pop the last note added to the default stack:

```
$ notes pop -d
```

Or you can pop by index:

```
$ notes pop -d 1
```

### Custom stacks

To create a custom stack:

```
$ notes -n bolc
```

Then you can push to that stack:

```
$ notes push bolc get new boots
```

And display that stack: 

```
$ notes stack bolc
[0] get new boots
```

Popping off that stack works the same way as default stack.

```
$ notes pop bolc
```

or pop at index...

```
$ notes pop bolc 0
```

To see all your stacks:

```
$ notes stack -l
default
notes
dhamma_letter
bolc
sfs
```

To see all your notes on all your stacks:

```
$ notes stack -a
*default*
[0] read
[1] stretch
[2] go for a run
----
*notes*
[0] create help message
[1] exit if error or show help, de nest logic after
[2] better error messages
[3] order notes when listing by date
[4] search by date
[5] open journal yesterday/tomorrow
----
*dhamma_letter*
[0] edit 12 + 13
[1] download website content
----
*bolc*
[0] get new boots
----
*sfs*
[0] update doorvest model
```

And to remove a stack:

```
$ notes stack -r bolc
```

# Helpful Aliases

```
alias scratch="notes scratch"
alias journal="notes journal"
alias stack="notes stack"
alias push="notes push"
alias pop="notes pop"
alias search="notes search"
```
