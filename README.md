Devisualization image loading/exporting
=====
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/Devisualization/image?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Scope
-----
Loading and exporting of different image file types.
Abstracted into a common image interface.

TODO
-----
__Common:__
- More formats other then PNG format e.g. TIFF, BMP.
- Common manipulation actions such as resizing, scaling, rotate

__PNG:__
Importing:
- Adam7 interlacing undo'ing
- Chunks: BKGD, hIST, pHYs, tIME, tRNS, zTXt
- Applying color manipulation (gAMA chunk)
- Non rgba color convertion to usable type

Exporting:
- Adam7 interlacing do'ing
- Chunks: BKGD, hIST, pHYs, tIME, tRNS, zTXt
- Color correction (can we even get this?) (gAMA chunk)