/* CoreGraphics - CGGeometry.h
 Copyright (c) 1998-2009 Apple Inc.
 All rights reserved. */

#ifndef OKGEOMETRY_H_
#define OKGEOMETRY_H_

#include <CoreGraphics/CGBase.h>
#include <CoreFoundation/CFDictionary.h>

/* Points. */

struct OKPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};
typedef struct OKPoint OKPoint;

/* Sizes. */

struct OKSize {
    CGFloat width;
    CGFloat height;
    CGFloat depth;
};
typedef struct OKSize OKSize;

/* Make a point from `(x, y)'. */

CG_INLINE OKPoint OKPointMake(CGFloat x, CGFloat y, CGFloat z);

/* Make a size from `(width, height)'. */

CG_INLINE OKSize OKSizeMake(CGFloat width, CGFloat height, CGFloat depth);

/* Return true if `point1' and `point2' are the same, false otherwise. */

CG_EXTERN bool OKPointEqualToPoint(OKPoint point1, OKPoint point2)
CG_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_2_0);

/* Return true if `size1' and `size2' are the same, false otherwise. */

CG_EXTERN bool OKSizeEqualToSize(OKSize size1, OKSize size2)
CG_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_2_0);

/*** Definitions of inline functions. ***/

CG_INLINE OKPoint
OKPointMake(CGFloat x, CGFloat y, CGFloat z)
{
    OKPoint p; p.x = x; p.y = y; p.z = z; return p;
}

CG_INLINE OKSize
OKSizeMake(CGFloat width, CGFloat height, CGFloat depth)
{
    OKSize size; size.width = width; size.height = height; size.depth = depth; return size;
}

CG_INLINE bool
__OKPointEqualToPoint(OKPoint point1, OKPoint point2)
{
    return point1.x == point2.x && point1.y == point2.y && point1.z == point2.z;
}
#define OKPointEqualToPoint __OKPointEqualToPoint

CG_INLINE bool
__OKSizeEqualToSize(OKSize size1, OKSize size2)
{
    return size1.width == size2.width && size1.height == size2.height && size1.depth == size2.depth;
}
#define OKSizeEqualToSize __OKSizeEqualToSize

#endif /* OKGEOMETRY_H_ */
