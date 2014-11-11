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
- Memory Image "format"
- Common manipulation interface in Image

__PNG:__
Importing:
- Pixel export to usable format
- Adam7 interlacing undo'ing
- Chunks: BKGD, hIST, pHYs, tIME, tRNS, zTXt
- Applying color manipulation (gAMA chunk)

Exporting:
- Not started