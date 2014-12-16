module devisualization.image.mutable.manipulation;
import devisualization.image.mutable.image;
public import devisualization.image.manipulation;
import devisualization.image;
import devisualization.util.core.linegraph;

/**
 * Resizes and crops an image.
 * 
 * If the newWidth + newHeight is less then the original then it is automatically cropped to that size.
 * If the newWidth + newHeight is more then the origianl then it is automatically resized.
 * 
 * Params:
 * 		old			=	The old image to copy from
 * 		newWidth	=	The new width of the image
 * 		newHeight	=	The new height of the image
 * 		startX		=	The offset x position (where to start copying from)
 * 		startY 		=	The offset y position (where to start copying from)
 * 		background	=	Empty pixels become this
 * 
 * TODO:
 * 		Actually apply the background
 * 
 * Returns:
 * 		Croped and resized image.
 */
MutableImage resizeCrop(Image old, size_t newWidth, size_t newHeight, size_t startX = 0, size_t startY = 0, Color_RGBA background = null)
in {
	assert(startX < old.width);
	assert(startY < old.height);
} body {
	MutableImage ret = new MutableImage(newWidth, newHeight);
	auto _ = ret.rgba;
	auto __ = old.rgba;

	size_t xx;
	size_t yy;

	size_t endY = startY + newHeight;
	if (endY > old.height)
		endY = old.height;

	foreach(y; startY .. endY) {
		xx = 0;

		size_t endX = startX + newWidth;
		if (endX > old.width)
			endX = old.width;

		foreach(x; startX .. endX) {
			_[_.indexFromXY(xx, yy)] = __[__.indexFromXY(x, y)];

			xx++;
		}

		yy++;
	}

	return ret;
}

/**
 * Copies an image and horizontally skews it.
 * 
 * Params:
 * 		old			=	The old image to copy from
 * 		angle		=	Angle from which to rotate, max 45. Negative angle skews to the left, otherwise right.
 * 		background	=	Empty pixels become this
 * 
 * Returns:
 * 		The skewed image
 */
MutableImage skewHorizontal(Image old, float angle, Color_RGBA background)
in {
	assert(angle >= -45);
	assert(angle <= 45);
} body {
	import std.math : atan, floor, ceil;
	enum float CONVERT = 100/90;

	bool negAngle = angle < 0;
	if (negAngle)
		angle *= -1;

	float widthHeight90 = ((45 - angle) * CONVERT) / 100;
	widthHeight90 *= old.width;
	float diffX = widthHeight90;

	MutableImage ret = new MutableImage(cast(size_t)floor(widthHeight90 + old.width), old.height);

	float xx = 0;
	float negxx = diffX;
	diffX = diffX / ret.height;

	auto _ = ret.rgba;
	auto __ = old.rgba;

	for(size_t yy = 1; yy <= ret.height; yy++) {
		size_t y = ret.height - yy;

		if (negAngle) {
			foreach(size_t x; 0 .. cast(size_t)ceil(negxx)) {
				_[_.indexFromXY(x, y)] = background;
			}
			
			foreach(size_t x; cast(size_t)floor(ret.width - xx) .. cast(size_t)ret.width) {
				_[_.indexFromXY(x, y)] = background;
			}
		} else {
			foreach(size_t x; 0 .. cast(size_t)ceil(xx)) {
				_[_.indexFromXY(x, y)] = background;
			}

			foreach(size_t x; cast(size_t)floor(ret.width - negxx) .. cast(size_t)ret.width) {
				_[_.indexFromXY(x, y)] = background;
			}
		}

		for(size_t x; x < old.width; x++) {
			if (negAngle)
				_[_.indexFromXY(cast(size_t)ceil(x + negxx), y)] = __[__.indexFromXY(x, y)];
			else
				_[_.indexFromXY(cast(size_t)ceil(x + xx), y)] = __[__.indexFromXY(x, y)];
		}

		negxx -= diffX;
		xx += diffX;
	}

	return ret;
}

/**
 * Copies an image and vertically skews it.
 * 
 * Params:
 * 		old			=	The old image to copy from
 * 		angle		=	Angle from which to rotate, max 45. Negative angle skews to the left, otherwise right.
 * 		background	=	Empty pixels become this
 * 
 * Returns:
 * 		The skewed image
 */
MutableImage skewVertical(Image old, float angle, Color_RGBA background)
in {
	assert(angle >= -45);
	assert(angle <= 45);
} body {
	import std.math : atan, floor, ceil;
	enum float CONVERT = 100/90;

	angle *= -1;
	bool negAngle = angle < 0;
	if (negAngle)
		angle *= -1;
	
	float widthHeight90 = ((45 - angle) * CONVERT) / 100;
	widthHeight90 *= old.height;
	float diffY = widthHeight90;
	
	MutableImage ret = new MutableImage(old.width, cast(size_t)floor(widthHeight90 + old.height));
	
	float yy = 0;
	float negyy = diffY-1;
	diffY = diffY / ret.width;
	
	auto _ = ret.rgba;
	auto __ = old.rgba;
	
	for(size_t xx = 1; xx < ret.width; xx++) {
		size_t x = ret.width - xx;

		// skew to the right
		// else skew to the left
		if (negAngle) {
			// left edge
			foreach(size_t y; 0 .. cast(size_t)ceil(negyy)) {
				_[_.indexFromXY(x, y)] = background;
			}

			// right edge
			foreach(size_t y; cast(size_t)floor(ret.height - yy) .. cast(size_t)ret.height) {
				_[_.indexFromXY(x, y)] = background;
			}
		} else {
			// left edge
			foreach(size_t y; 0 .. cast(size_t)ceil(yy)) {
				_[_.indexFromXY(x, y)] = background;
			}

			// right edge
			foreach(size_t y; cast(size_t)floor(ret.height - negyy) .. cast(size_t)ret.height) {
				_[_.indexFromXY(x, y)] = background;
			}
		}

		// copy contents
		for(size_t y; y < old.height; y++) {
			if (negAngle)
				_[_.indexFromXY(x, cast(size_t)ceil(y + negyy))] = __[__.indexFromXY(x, y)];
			else
				_[_.indexFromXY(x, cast(size_t)ceil(y + yy))] = __[__.indexFromXY(x, y)];
		}
		
		negyy -= diffY;
		yy += diffY;
	}
	
	return ret;
}

/**
 * Rotates an image 90 degrees.
 *
 * Params:
 * 		_			=	The image
 * 		clockwise	=	Rotate clockwise instead of anti-clockwise. Default: true
 *
 * Returns:
 *		The rotated image.
 */
MutableImage rotate90(Image _, bool clockwise=true) {
	MutableImage ret = new MutableImage(_.height, _.width);
	auto __ = ret.rgba;

	void cd(Color_RGBA c, size_t x, size_t yy) {
		size_t y;
		if (clockwise)
			y = _.height - (yy + 1);
		else
			y = yy;

		__[__.indexFromXY(y, x)] = c;
	}
	_.applyByY(&cd);

	return ret;
}

/**
 * Applies a Convolution-2d filter upon an image
 *
 * Params:
 * 		_		=	The image to apply the filter to
 *		k_		=	The kernel for how to apply the filter
 * 		ret		=	The output instance of MutableImage to put into
 * 		paths	=	Paths to get the pixels from
 *
 * See_Also:
 *		http://www.songho.ca/dsp/convolution/convolution.html#convolution_2d
 *
 * Returns:
 *		The filtered image
 */
void convolution2d(Image _, Image k_, ref MutableImage ret, LineGraph[] paths...) {
	import std.math : floor;

	auto __ = ret.rgba;
	auto ___ = _.rgba;
	auto k___ = k_.rgba;
	
	size_t cx = cast(size_t)floor(k_.width / 2f);
	size_t cy = cast(size_t)floor(k_.height / 2f);

	void p(size_t i, size_t j) {
		__[__.indexFromXY(j, i)].r = 0;
		__[__.indexFromXY(j, i)].g = 0;
		__[__.indexFromXY(j, i)].b = 0;
		__[__.indexFromXY(j, i)].a = ___[___.indexFromXY(j, i)].a;
		
		for(size_t m = 0; m < k_.height; m++) {
			size_t mm = k_.height - 1 - m;
			
			for(size_t n = 0; n < k_.width; n++) {
				size_t nn = k_.width - 1 - n;
				
				ptrdiff_t ii = i + (m - cy);
				ptrdiff_t jj = j + (n - cx);
				
				if (ii >= 0 && ii < _.height && jj >= 0 && jj < _.width) {
					float fr = (k___[k___.indexFromXY(nn, mm)].r + 0f) / ushort.max;
					float fg = (k___[k___.indexFromXY(nn, mm)].g + 0f) / ushort.max;
					float fb = (k___[k___.indexFromXY(nn, mm)].b + 0f) / ushort.max;
					
					__[__.indexFromXY(j, i)].r += cast(ushort)(___[___.indexFromXY(jj, ii)].r * fr);
					__[__.indexFromXY(j, i)].g += cast(ushort)(___[___.indexFromXY(jj, ii)].g * fg);
					__[__.indexFromXY(j, i)].b += cast(ushort)(___[___.indexFromXY(jj, ii)].b * fb);
				}
				
			}
		}
	}
	foreach(path; paths) {
		path.apply(&p);
	}
}


/**
 * Applies a Convolution-2d filter upon an image
 *
 * Params:
 * 		_	=	The image to apply the filter to
 *		k_	=	The kernel for how to apply the filter
 *
 * See_Also:
 *		http://www.songho.ca/dsp/convolution/convolution.html#convolution_2d
 *
 * Returns:
 *		The filtered image
 */
MutableImage convolution2d(Image _, Image k_) {
	import std.math : floor;

	MutableImage ret = new MutableImage(_.width, _.height);
	auto __ = ret.rgba;
	auto ___ = _.rgba;
	auto k___ = k_.rgba;

	size_t cx = cast(size_t)floor(k_.width / 2f);
	size_t cy = cast(size_t)floor(k_.height / 2f);

	for (size_t i = 0; i < _.height; i++) {
		for(size_t j = 0; j < _.width; j++) {
			__[__.indexFromXY(j, i)].r = 0;
			__[__.indexFromXY(j, i)].g = 0;
			__[__.indexFromXY(j, i)].b = 0;
			__[__.indexFromXY(j, i)].a = ___[___.indexFromXY(j, i)].a;

			for(size_t m = 0; m < k_.height; m++) {
				size_t mm = k_.height - 1 - m;

				for(size_t n = 0; n < k_.width; n++) {
					size_t nn = k_.width - 1 - n;

					ptrdiff_t ii = i + (m - cy);
					ptrdiff_t jj = j + (n - cx);

					if (ii >= 0 && ii < _.height && jj >= 0 && jj < _.width) {
						float fr = (k___[k___.indexFromXY(nn, mm)].r + 0f) / ushort.max;
						float fg = (k___[k___.indexFromXY(nn, mm)].g + 0f) / ushort.max;
						float fb = (k___[k___.indexFromXY(nn, mm)].b + 0f) / ushort.max;

						__[__.indexFromXY(j, i)].r += cast(ushort)(___[___.indexFromXY(jj, ii)].r * fr);
						__[__.indexFromXY(j, i)].g += cast(ushort)(___[___.indexFromXY(jj, ii)].g * fg);
						__[__.indexFromXY(j, i)].b += cast(ushort)(___[___.indexFromXY(jj, ii)].b * fb);
					}

				}
			}
		}
	}

	return ret;
}

/**
 * Applies a gaussian blur based with a custom kernel applied.
 * Uses a standard kernel from: http://www.songho.ca/dsp/convolution/convolution.html#convolution_2d
 * 
 * Params:
 * 		_		=	The image to filter
 * 
 * See_Also:
 * 		http://www.songho.ca/dsp/convolution/convolution.html#convolution_2d
 * 
 * Returns:
 * 		The blured image
 */
MutableImage gaussianBlur(Image _) {
	static __gshared Image filter;
	if (filter is null) {
		filter = new MutableImage(3, 3, 
           [new Color_RGBA(1/16f, 1/16f, 1/16f, 1/16f), new Color_RGBA(2/16f, 2/16f, 2/16f, 2/16f), new Color_RGBA(1/16f, 1/16f, 1/16f, 1/16f), 
			new Color_RGBA(2/16f, 2/16f, 2/16f, 2/16f), new Color_RGBA(4/16f, 4/16f, 4/16f, 4/16f), new Color_RGBA(2/16f, 2/16f, 2/16f, 2/16f), 
			new Color_RGBA(1/16f, 1/16f, 1/16f, 1/16f), new Color_RGBA(2/16f, 2/16f, 2/16f, 2/16f), new Color_RGBA(1/16f, 1/16f, 1/16f, 1/16f)]);
	}

	return convolution2d(_, filter);
}

/**
 * Applies a gaussian blur based with a custom kernel applied.
 * 
 * Params:
 * 		_		=	The image to filter
 * 		radius	=	The radius of the blur
 * 		weight	=	Weighting of the blur
 * 
 * Returns:
 * 		The blured image
 */
MutableImage gaussianBlur(Image _, size_t radius, float weight) {
	return null;
}

/**
 * Creates a kernel for a gaussian blur
 * 
 * Params:
 * 		radius	=	The radius of the blur
 * 		weight	=	Weighting of the blur
 * 
 * See_Also:
 * 		http://www.apileofgrains.nl/blur-filters-c/
 * 
 * Returns:
 * 		The kernel
 */
Image gaussianBlurKernel(size_t radius, float weight) {
	return null;
}