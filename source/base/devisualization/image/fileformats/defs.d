/**
 * Common file format definitions
 * 
 * License:
 *              Copyright Devisualization (Richard Andrew Cattermole) 2014 - 2017.
 *     Distributed under the Boost Software License, Version 1.0.
 *        (See accompanying file LICENSE_1_0.txt or copy at
 *              http://www.boost.org/LICENSE_1_0.txt)
 */
module devisualization.image.fileformats.defs;

/**
 * An image format type with color type of HeadersOnly will not include the image facilities as part of it.
 * This is used with loading only headers of and image format type. To decide at runtime a better color type to use.
 */
struct HeadersOnly {}

///
alias ImageNotLoadableException = Exception;

///
alias ImageNotExportableException = Exception;