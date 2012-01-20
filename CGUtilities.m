//
//  CGUtilities.m
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CGUtilities.h"

#pragma mark Path creation

// Based on http://www.raywenderlich.com/
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight) 
{ 
    CGRect arcRect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - arcHeight, 
                                rect.size.width, arcHeight);

    CGFloat arcRadius = (arcRect.size.height / 2) + (pow(arcRect.size.width, 2) / (8 * arcRect.size.height));
    CGPoint arcCenter = CGPointMake(arcRect.origin.x + arcRect.size.width / 2, arcRect.origin.y + arcRadius);

    CGFloat angle = acos(arcRect.size.width / (2 * arcRadius));
    CGFloat startAngle = radians(180) + angle;
    CGFloat endAngle = radians(360) - angle;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, arcCenter.x, arcCenter.y, arcRadius, startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));

    return path;
}

// Based on http://goo.gl/iG84t
void CGContextAddRoundedRect(CGContextRef context, CGRect rect, CGFloat radius)
{
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect); 
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect); 

    // Go around the rectangle in the order given by the figure below:
    //       minx    midx    maxx 
    // miny    2       3       4 
    // midy    1       9       5 
    // maxy    8       7       6 
    
    // Start at 1 
    CGContextMoveToPoint(context, minx, midy); 
    // Add an arc through 2 to 3 
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius); 
    // Add an arc through 4 to 5 
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius); 
    // Add an arc through 6 to 7 
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius); 
    // Add an arc through 8 to 9 
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius); 
    
    // Close the path 
    CGContextClosePath(context);
}

#pragma mark - Drawing operations

void CGContextDrawInnerBoxShadow(CGContextRef context, CGRect rect, CGSize offset, CGFloat blur, CGColorRef color)
{
    // This value doesn't really matter - just > 0
    CGFloat outsideOffset = 40.0;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    // Create a rect larger than the one passed as parameter
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -outsideOffset, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, width + outsideOffset, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, width + outsideOffset, height + outsideOffset);
    CGPathAddLineToPoint(path, NULL, -outsideOffset, height + outsideOffset);
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, offset, blur, color);       

    // Now fill the rectangle, so the shadow gets drawn
    UIColor *randomColor = [UIColor colorWithWhite:1.f alpha:1.f];
    [randomColor setFill];   

    CGContextAddPath(context, path);
    CGContextAddRect(context, rect);
    CGContextEOFillPath(context);

}

void CGContextDrawLine(CGContextRef context, CGPoint start, CGPoint end, CGColorRef color)
{
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextSetStrokeColorWithColor(context, color);
    CGContextMoveToPoint(context, start.x + 0.5, start.y + 0.5);
    CGContextAddLineToPoint(context, end.x + 0.5, end.y + 0.5);
    CGContextStrokePath(context);
}

void CGContextDrawBorder(CGContextRef context, CGRect rect, CGFloat width, CFArrayRef colors)
{
    if (CFArrayGetCount(colors) == 0) {
        NSLog(@"%@: did not receive colors", __PRETTY_FUNCTION__);
        return;
    }
    
    // Top
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(CGRectGetMaxX(rect), start.y);
    CGColorRef colorBorderTop = (CGColorRef)CFArrayGetValueAtIndex(colors, 0);
    CGContextDrawLine(context, start, end, colorBorderTop);

    // Right
    start = end;
    end.y = CGRectGetMaxY(rect);
    if (CFArrayGetCount(colors) > 1) {
        CGColorRef colorBorderRight = (CGColorRef)CFArrayGetValueAtIndex(colors, 1);
        CGContextDrawLine(context, start, end, colorBorderRight);        
    } else {
        return;
    }
    
    // Bottom
    start = end;
    end.x = rect.origin.x;
    if (CFArrayGetCount(colors) > 2) {
        CGColorRef colorBorderBottom = (CGColorRef)CFArrayGetValueAtIndex(colors, 2);
        CGContextDrawLine(context, start, end, colorBorderBottom); 
    } else {
        return;
    }

    // Left border
    start = end;
    end.y = rect.origin.y;
    if (CFArrayGetCount(colors) > 3) {
        CGColorRef colorBorderLeft = (CGColorRef)CFArrayGetValueAtIndex(colors, 3);
        CGContextDrawLine(context, start, end, colorBorderLeft); 
    } else {
        return;
    }
}
