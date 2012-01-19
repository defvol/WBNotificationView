//
//  WBNotificationView.m
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WBNotificationView.h"
#import <QuartzCore/QuartzCore.h>

// Default notification messages

#define kMessageError     @"Oh snap! Change this and that and try again."
#define kMessageWarning   @"Holy guacamole! Best check yo self, you’re not looking too good."
#define kMessageSuccess   @"Well done! You successfully read this alert message."
#define kMessageInfo      @"Heads up! This is an alert that needs your attention, but it’s not a huge priority just yet."

// Default colors

#define kGradientColorErrorTop      [UIColor colorWithRed:238.0/255.0 green:095.0/255.0 blue:091.0/255.0 alpha:1.00] // #EE5F5B
#define kGradientColorErrorBottom   [UIColor colorWithRed:196.0/255.0 green:060.0/255.0 blue:053.0/255.0 alpha:1.00] // #C43C35
#define kBorderColorErrorTop        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.10]
#define kBorderColorErrorRight      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.10]
#define kBorderColorErrorBottom     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]
#define kBorderColorErrorLeft       [UIColor colorWithRed:0 green:0 blue:0 alpha:0.10]

#define kGradientColorWarningBottom [UIColor colorWithRed:238.0/255.0 green:220.0/255.0 blue:148.0/255.0 alpha:1.00] // #EEDC94
#define kGradientColorSuccessBottom [UIColor colorWithRed:087.0/255.0 green:169.0/255.0 blue:087.0/255.0 alpha:1.00] // #57A957
#define kGradientColorInfoBottom    [UIColor colorWithRed:051.0/255.0 green:155.0/255.0 blue:185.0/255.0 alpha:1.00] // #339BB9

// Message box defaults

#define kBoxShadowColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25]
#define kHeight          40.0
#define kPadding         10.0
#define kBorderRadius    04.0

// Helpers

#define kMessageLabelViewTag    1001
#define INVERT_SIGN(x)          ~x + 1

typedef void (^completionBlock)(BOOL);

@implementation WBNotificationView
{
    BOOL sliding;    
    UIColor *gradientColorTop;
    UIColor *gradientColorBottom;
    NSArray *borderColors;
    UILabel *messageLabel;
}

@synthesize type = _type;
@synthesize message = _message;

- (void)setType:(WBNotificationViewType)type
{
    _type = type;
    
    gradientColorTop = nil;
    gradientColorBottom = nil;
    borderColors = nil;
    
    // Updates gradient colors when changing notification type
    switch (_type) {
        case WBNotificationViewTypeError:
            gradientColorTop = kGradientColorErrorTop;
            gradientColorBottom = kGradientColorErrorBottom;
            borderColors = [NSArray arrayWithObjects:kBorderColorErrorTop, kBorderColorErrorRight, kBorderColorErrorBottom, kBorderColorErrorLeft, nil];
            break;
        case WBNotificationViewTypeInfo:
            gradientColorTop = kGradientColorInfoBottom;
            gradientColorBottom = kGradientColorInfoBottom;
            break;
        case WBNotificationViewTypeSuccess:
            gradientColorTop = kGradientColorSuccessBottom;
            gradientColorBottom = kGradientColorSuccessBottom;
            break;
        case WBNotificationViewTypeWarning:
            gradientColorTop = kGradientColorWarningBottom;
            gradientColorBottom = kGradientColorWarningBottom;
            break;
        default:
            gradientColorTop = kGradientColorInfoBottom;
            gradientColorBottom = kGradientColorInfoBottom;
    }
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    // Update label
    // TODO: should we add setNeedsDisplay?
    messageLabel.text = _message;
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Add UILabel
        CGRect _frame = CGRectMake(kPadding, 0, self.frame.size.width - kPadding * 2, self.frame.size.height);
        _frame.size.height = ceilf(kHeight / 2.0);
        _frame.origin.y = ceilf(kHeight / 2.0 - _frame.size.height / 2.0);
        messageLabel = nil;
        messageLabel = [[UILabel alloc] initWithFrame:_frame];
        messageLabel.text = nil;
        messageLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.tag = kMessageLabelViewTag;
        [self addSubview:messageLabel];
        
        // Layer style
        self.layer.cornerRadius = kBorderRadius;
        self.layer.masksToBounds = YES;
        self.layer.frame = CGRectInset(self.layer.frame, 2, 0);
    }
    return self;
}

#pragma mark - Drawing operations

- (void)drawLineColored:(UIColor *)color startingAt:(CGPoint)start endingAt:(CGPoint)end using:(CGContextRef)_context
{
    CGContextSetStrokeColorWithColor(_context, color.CGColor);
    CGContextMoveToPoint(_context, start.x, start.y);
    CGContextAddLineToPoint(_context, end.x, end.y);
    CGContextStrokePath(_context);
}

- (void)drawBorder:(CGContextRef)_context
{
    // Stroke defaults
    CGRect strokeRect = self.bounds;
    CGContextSetLineCap(_context, kCGLineCapSquare);
    CGContextSetLineWidth(_context, 1.0);

    // INFO: The famous "half-pixel fix" needed when drawing lines http://bit.ly/bc3qxx 
    
    // Top border
    CGPoint startPosition = CGPointMake(strokeRect.origin.x + 0.5, strokeRect.origin.y + 0.5);
    CGPoint endPosition = CGPointMake(CGRectGetMaxX(strokeRect) + 0.5, startPosition.y);    
    UIColor *borderColor = (UIColor *)[borderColors objectAtIndex:0];
    [self drawLineColored:borderColor startingAt:startPosition endingAt:endPosition using:_context];
    
    // Right border
    startPosition = endPosition;
    endPosition.y = CGRectGetMaxY(strokeRect) + 0.5;
    borderColor = nil;
    borderColor = (UIColor *)[borderColors objectAtIndex:1];
    [self drawLineColored:borderColor startingAt:startPosition endingAt:endPosition using:_context];
    
    // Bottom border
    startPosition = endPosition;
    endPosition.x = strokeRect.origin.x + 0.5;
    borderColor = nil;
    borderColor = (UIColor *)[borderColors objectAtIndex:2];
    [self drawLineColored:borderColor startingAt:startPosition endingAt:endPosition using:_context];

    // Left border
    startPosition = endPosition;
    endPosition.y = strokeRect.origin.y + 0.5;
    borderColor = nil;
    borderColor = (UIColor *)[borderColors objectAtIndex:3];
    [self drawLineColored:borderColor startingAt:startPosition endingAt:endPosition using:_context];
}

- (void)drawRect:(CGRect)rect 
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(id)gradientColorTop.CGColor, (id)gradientColorBottom.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextRef _context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(_context);
    {
        // First the background
        CGContextSetFillColorWithColor(_context, gradientColorBottom.CGColor);
        CGContextFillRect(_context, self.bounds);

        // Then the gradient
        CGContextAddRect(_context, rect);
        CGContextClip(_context);
        CGContextDrawLinearGradient(_context, gradient, startPoint, endPoint, 0);
        
        // Finally the border
        [self drawBorder:_context];
        
        // Don't forget the shadow
        // TODO: Inner shadow pending 
        // CGContextSetShadowWithColor(_context, CGSizeMake(0, 1), 0, kBoxShadowColor.CGColor);
    }
    CGContextRestoreGState(_context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);    
}

#pragma mark - UI

- (void)performSlideToFrame:(CGRect)newFrame finishingWith:(completionBlock)routine
{
    // To have some atomicity
    if (sliding) 
        return;
    else
        sliding = YES;
    
    if (routine == nil) {
        routine = ^(BOOL finished) {
            sliding = NO;
        };
    }
        
    [UIView animateWithDuration:0.5 
        delay:0 
        options:UIViewAnimationCurveLinear 
        animations:^{
            self.frame = newFrame;
        } 
        completion:routine]; 
}

- (void)performSlideToFrame:(CGRect)newFrame {
    [self performSlideToFrame:newFrame finishingWith:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (sliding == NO)
        [self slideOut];
}

- (void)slideInFinishingWith:(completionBlock)routine
{
    CGRect _frame = self.frame;
    // Moves the frame to the top of the main view
    _frame.origin.y = 0.0;    
    [self performSlideToFrame:_frame finishingWith:routine];
}

#pragma mark - API

- (id)initWithMessage:(NSString *)aMessage ofType:(WBNotificationViewType)aType
{
    // TODO: support landscape mode
    self = [self initWithFrame:CGRectMake(0, -kHeight, 320, kHeight)];
    if (self) {
        self.message = aMessage;
        self.type = aType;
    }
    return self;
}

- (void)slideIn {
    [self slideInFinishingWith:nil];
}

- (void)slideOut
{
    CGRect _frame = self.frame;
    // Moves the frame just above the main view
    _frame.origin.y = INVERT_SIGN(lround(_frame.size.height));    
    [self performSlideToFrame:_frame];
}

- (void)slideInDisappearingIn:(NSTimeInterval)seconds 
{
    [self slideInFinishingWith:^(BOOL finished) {
        sliding = NO;
        [self performSelector:@selector(slideOut) withObject:nil afterDelay:seconds];
    }];
}

@end
