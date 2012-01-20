//
//  CGUtilities.h
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline double radians (double degrees) { return degrees * M_PI/180; }

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);
void CGContextAddRoundedRect(CGContextRef context, CGRect rect, CGFloat cornerRadius);

void CGContextDrawInnerBoxShadow(CGContextRef context, CGRect rect, CGSize offset, CGFloat blur, CGColorRef color);
void CGContextDrawLine(CGContextRef context, CGPoint start, CGPoint end, CGColorRef color);
void CGContextDrawBorder(CGContextRef context, CGRect rect, CGFloat width, CFArrayRef colors);
