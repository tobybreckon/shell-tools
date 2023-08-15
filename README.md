# shell-tools
a small set of useful Unix / Linux command line tools

```
Usage: lowername [-voUsScCrd] files
-v verbose mode
-o overwrite files if they already exist
-U lowercase letters to UPPERCASE (reverse operation)
-s remove spaces in filenames (in addition)
-S remove spaces in filenames (only, no case changes)
-c clean filenames (in addition, remove non-alphanumeric except  ".-_")
-C clean filenames (only, ... but with no case changes)
-r recursive mode - recurse through directories
-d dry-run - show potential changes with no file changes

Translate uppercase filenames to lowercase.

Author: Toby Breckon, 1999-2021
```

```
Usage: numberfile [-p prefix -t tail | files]
-p prefix: prefix for numbered files
-t tail: tail (postfix) for numbered files

number a set of files as prefix00001 prefix00002 etc
from specified list of files on command line.

Author: Toby Breckon, November 2010
```

```
Usage: opensuse-package-install.sh [chrome | zoom | skype | teams | 
                             vscode | edge | f5vpn | atom  | 
                             dropbox | ximea | brackets | cuda |
                             cudnn | clamav | pdfjam-extras | patterns | 
                             libreoffice-extensions | laptop-extras |
                             packaging | opencv-extras | baseline | ... ]

[ "a quick hack" by Toby Breckon, 2022+ ]
```

```
Usage: ubuntu-package-install.sh [repos | chrome | zoom | skype | teams | 
                               vscode | edge | ximea | cuda |
                               cudnn | opencv-extras | baseline | ... ]

[ "a quick hack" by Toby Breckon, 2022+ ]
```

```
Usage: randomfile [-f listfile | files]
-f listfile : specify a file containing a list of files

Randomly select a file from specified list file or
from specified list of files on command line.

Author: Toby Breckon, July 2006
```

```
Usage: video-to-gif-clip.sh skipsecs length scale input output

skipsecs = number of seconds to skip at start
length = length of clip in secs
scale = scale factor for height and width (use 1 for no change)
input = path to input video
output = path to output gif
```

```
Usage: video-target-size.sh video size
video = video file
size = size in MB (integer or float)
```

