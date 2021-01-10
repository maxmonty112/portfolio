# Notes

A minamlist command-line interface for note taking and organization, journaling, and task-tracking/managment written in ruby inspired by (and emulative of) Max Hodak's note-taking [system](https://github.com/maxhodak/notes) written in python. 

### Installation
1. Clone repo
2. Export `$NOTESPATH` (where you want your notes to be saved) and `$NOTESCRIPT` (where you cloned this repo) from your `.bash_profile`: 

    ```
    export NOTESPATH="/path/to/home/documents/notes"
    export NOTESCRIPT="/path/to/where/you/cloned/repo/notes"
    ```
    
3. `cd` into repo and run the following commands:

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
    
   
