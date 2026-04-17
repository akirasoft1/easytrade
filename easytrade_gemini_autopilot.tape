# VHS documentation
#
# Output:
#   Output <path>.gif               Create a GIF output at the given <path>
#   Output <path>.mp4               Create an MP4 output at the given <path>
#   Output <path>.webm              Create a WebM output at the given <path>
#
# Require:
#   Require <string>                Ensure a program is on the $PATH to proceed
#
# Settings:
#   Set FontSize <number>           Set the font size of the terminal
#   Set FontFamily <string>         Set the font family of the terminal
#   Set Height <number>             Set the height of the terminal
#   Set Width <number>              Set the width of the terminal
#   Set LetterSpacing <float>       Set the font letter spacing (tracking)
#   Set LineHeight <float>          Set the font line height
#   Set LoopOffset <float>%         Set the starting frame offset for the GIF loop
#   Set Theme <json|string>         Set the theme of the terminal
#   Set Padding <number>            Set the padding of the terminal
#   Set Framerate <number>          Set the framerate of the recording
#   Set PlaybackSpeed <float>       Set the playback speed of the recording
#   Set MarginFill <file|#000000>   Set the file or color the margin will be filled with.
#   Set Margin <number>             Set the size of the margin. Has no effect if MarginFill isn't set.
#   Set BorderRadius <number>       Set terminal border radius, in pixels.
#   Set WindowBar <string>          Set window bar type. (one of: Rings, RingsRight, Colorful, ColorfulRight)
#   Set WindowBarSize <number>      Set window bar size, in pixels. Default is 40.
#   Set TypingSpeed <time>          Set the typing speed of the terminal. Default is 50ms.
#
# Sleep:
#   Sleep <time>                    Sleep for a set amount of <time> in seconds
#
# Type:
#   Type[@<time>] "<characters>"    Type <characters> into the terminal with a
#                                   <time> delay between each character
#
# Keys:
#   Escape[@<time>] [number]        Press the Escape key
#   Backspace[@<time>] [number]     Press the Backspace key
#   Delete[@<time>] [number]        Press the Delete key
#   Insert[@<time>] [number]        Press the Insert key
#   Down[@<time>] [number]          Press the Down key
#   Enter[@<time>] [number]         Press the Enter key
#   Space[@<time>] [number]         Press the Space key
#   Tab[@<time>] [number]           Press the Tab key
#   Left[@<time>] [number]          Press the Left Arrow key
#   Right[@<time>] [number]         Press the Right Arrow key
#   Up[@<time>] [number]            Press the Up Arrow key
#   Down[@<time>] [number]          Press the Down Arrow key
#   PageUp[@<time>] [number]        Press the Page Up key
#   PageDown[@<time>] [number]      Press the Page Down key
#   Ctrl+<key>                      Press the Control key + <key> (e.g. Ctrl+C)
#
# Display:
#   Hide                            Hide the subsequent commands from the output
#   Show                            Show the subsequent commands in the output

Output easytrade_gemini_autopilot.gif

Require echo

Set Shell "zsh"
Set FontSize 32
Set Width 1200
Set Height 600

Type "echo 'Welcome to VHS!'" Sleep 500ms  Enter

Sleep 5s
Set Shell zsh
Sleep 9s
Type "gemini"
Sleep 1s
Type " --yolo"
Enter
Sleep 4s
Escape
Type "[?0u"
Escape
Type "[?64;1;2;4;6;17;18;21;22c"
Sleep 3s
Escape
Type "[O"
Sleep 1s
Escape
Type "[I"
Sleep 500ms
Type "as a TENURED "
Sleep 500ms
Backspace 8
Type "tenured SRE "
Sleep 1.5s
Type "skilled in the minute "
Sleep 1.5s
Type "nuances of GKE Au"
Sleep 500ms
Type "op"
Backspace 2
Type "topilot, "
Sleep 4.5s
Type "examine teh a"
Backspace 5
Type "the applications contained in this directory and all subdic"
Backspace
Type "rectories"
Sleep 1s
Type ". The applications will be specifically "
Sleep 500ms
Type "deployed by the "
Sleep 500ms
Backspace 2
Type "e manifests in @ku"
Tab
Sleep 1s
Type "re"
Tab
Sleep 2s
Type " "
Sleep 500ms
Type "Lets look speif"
Backspace 2
Type "cf"
Backspace
Sleep 500ms
Type "ifically "
Sleep 500ms
Type "for items that might be incorrectly configured for GKE A"
Sleep 500ms
Type "utopilot. Make a list of changes in recommended"
Sleep 500ms
Type "-updates.md"
Sleep 1s
Type ". "
Sleep 500ms
Type "Upon completion, provide a c"
Sleep 2s
Type "oncise list of the changes "
Sleep 500ms
Type "with a single p"
Backspace
Type "line per change"
Sleep 500ms
Backspace 6
Type "to the terminal output here."
Sleep 1s
Enter
Sleep 90s
Escape
Type "[O"
Sleep 7.5s
Escape
Type "[I"
Sleep 35s
Type "why did you remove limits? can you confirm that is necessary "
Sleep 500ms
Type "per exte"
Backspace 34
Type "cite sources fo"
Backspace 2
Type "recommende"
Backspace
Type "ing this change?"
Enter
Sleep 46.5s
Escape
Type "[O"
Sleep 3s
Escape
Type "[I"
Sleep 7s
Type "lts"
Backspace 4
Type "lets deply"
Backspace
Type "oy"
Sleep 500ms
Type " the easytrade application to the "
Sleep 500ms
Type "g"
Backspace
Type "mvilliger-autopilot-cluster1 "
Sleep 4.5s
Type "cluster, ensuring all workloads are "
Sleep 500ms
Type "depl"
Backspace 22
Type "the application is deployed to hte easy"
Backspace 8
Type "the easytrade namespace "
Sleep 500ms
Type "and continually check on the deployment progress reporting back here if there are any errors."
Enter
Sleep 897s
Escape
Type "[O"
Sleep 611s
Escape
Type "[I"
Sleep 14.5s
Escape
Type "[27u"
Sleep 18s
Escape
Type "[111;5u"
Sleep 500ms
Escape
Type "[O"
Sleep 1s
Escape
Type "[I"
Sleep 1s
Type "ø"
Sleep 500ms
Backspace 4
Sleep 4.5s
Type "/quit"
Sleep 500ms
Enter
Sleep 1s
Type "/quit"
Sleep 500ms
Backspace 5

