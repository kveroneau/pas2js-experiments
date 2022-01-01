# Canvas experiments

### loadmxs
This was a custom format developed by the O.H.R.RPG.C.E. Game Engine, originally made for MS-DOS, and still being
maintained til this day with ports of the game engine to modern platforms such as Linux, macOS, Android, and even Windows!

This project loads a binary file from the server using FMemoryStream, and displays it in a HTML5 Canvas.

Please be aware that this example will not work with stock pas2js, as it will load binary files as WideChars instead of bytes, I needed to make some modifications to the Rtl.BrowserLoadHelper unit to make it work.

I am thinking of discussing this feature of loading pure binary files with the pas2js devs to allow both methods of loading files from the server.
