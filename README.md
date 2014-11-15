Devisualization image loading/exporting
=====

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
- IDAT chunk
- Chunks: BKGD, hIST, pHYs, tIME, tRNS, zTXt
- Color correction (can we even get this?) (gAMA chunk)