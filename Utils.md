# Utilities


---
### How to change the default font size of XTerm?
* https://askubuntu.com/questions/161652/how-to-change-the-default-font-size-of-xterm
  
You can add the following as an example to your ```~/.Xresources``` file:

```
! Use a truetype font and size.
xterm*faceName: Monospace
xterm*faceSize: 14
```
Then run the following:
```
xrdb -merge ~/.Xresources
```
