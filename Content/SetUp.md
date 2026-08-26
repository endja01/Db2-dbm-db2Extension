# ---------------------------------------------------------------------------------------------------
# This file contains steps to setup your VS Code session. Additional details can be found in the pdf. 
# ---------------------------------------------------------------------------------------------------

# 1. Share clipboard? See text and images copied to the clipboard
#     Click Allow button to share clipboard
#  
# 2. Setup Ctrl/Enter via keybinds 
#     In VS Code open the keybindings.json file from the View => Command Palette (Ctrl+Shift+P) with 
#     the Preferences: Open Keyboard Shortcuts (JSON) command.
#
#     Copy/paste the below within the brackets [  ] in the keybindings.json file.
   {
     "key": "ctrl+enter",
     "command": "workbench.action.terminal.runSelectedText",
     "when": "editorTextFocus && editorHasSelection"
   }

#
#
#