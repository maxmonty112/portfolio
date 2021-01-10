# Notes

A minamlist command-line interface for note taking and organization, journaling, and task-tracking/managment written in ruby inspired by (and emulative of) Max Hodak's note-taking [system](https://github.com/maxhodak/notes) written in python. 

### Installation
Clone repo

Add the following to your `.bash_profile`: 

```
export NOTESPATH="/path/to/where/you/want/notes/saved"
export NOTESCRIPT="/path/to/where/you/cloned/this/repo"
```
    
Run the following commands inside repo:

```
make install
bundle install
```
    
### Usage

```
notes new <note> -- create new note
notes search [-ft] <phrase> --- search notes by name and or contents
notes scratch --- open scratch pad
notes edit <note> --- edit existing note
notes journal --- create/edit daily journal entry
notes [-h] --- show this message
notes stack [-adlnr] <title> --- create, delete, list, display stacks
notes push [-d] <stack> --- push to stack
notes pop [-d] <stack> <index> --- pop off stack
```

### Helpful Aliases

```
alias scratch="notes scratch"
alias journal="notes journal"
alias stack="notes stack"
alias push="notes push"
alias pop="notes pop"
alias search="notes search"
```
