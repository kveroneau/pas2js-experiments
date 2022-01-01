# Terminal Tests
I love creating terminals inside a browser, I just love command-line systems over modern GUIs, sue me!

These examples will need my `jslib` Lazarus package located here: https://github.com/kveroneau/jslib

### termtest1
This example project has a lot going on, as I was testing out a lot of various pas2js features in one single project.  You will need to generate the `gamedata/scenario.json` file yourself by running the included Python script, but this also enables you to easily modify the scenario data yourself, or make your own scenario data for `hackterm.pas`.  HackTerm aka HackRUN is based on a demo I played on Android years back aptly called HackRUN.  This is a recreation of that game engine in pas2js, along with the demo of the non-paid version.  I previous made this same engine in Python to learn jquery.terminal and WebSockets back in 2015.  That repo was lost when BitBucket.org trashed all Mercurial repos from their website.  I may soon re-upload a new repo with the Python version, although it is Python 2.7.

### termtest2
This example project was created to play around with the vt100.js JavaScript library and to build a pas2JS wrapper class for it.  So this is the project used to develop `webvt100` unit you can find in my `jslib` repo on GitHub.

### All needed JavaScript libraries are included
Although I cannot take credit for the stellar work done with `vt100.js`, `jquery.terminal`, `jquery`, `tvision.css`, and `MagicXML`.  They are all included here for completeness.  If the original authors of any of these projects would like me to remove the respective files from this repo, I will gladly comply.
