Devisualization image loading/exporting
=====

Scope
-----
Loading and exporting of different image file types.
Abstracted into a common image interface.

TODO
-----
Other than PNG format e.g. TIFF, BMP.

__PNG:__
Importing:
- Pixel export to usable format
- Adam7 interlacing undo'ing
- Chunks: BKGD, hIST, pHYs, tIME, tRNS, zTXt
- Applying color manipulation (gAMA chunk)

Exporting:
- Not started