//
//  WBNotificationView.m
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WBNotificationView.h"
#import "CGUtilities.h"

// Default notification messages

#define kMessageError     @"Oh snap! Change this and that and try again."
#define kMessageWarning   @"Holy guacamole! Best check yo self, you’re not looking too good."
#define kMessageSuccess   @"Well done! You successfully read this alert message."
#define kMessageInfo      @"Heads up! This is an alert that needs your attention, but it’s not a huge priority just yet."

// Default colors

#define kGradientColorErrorTop      [UIColor colorWithRed:238.0/255.0 green:095.0/255.0 blue:091.0/255.0 alpha:1.00] // #EE5F5B
#define kGradientColorErrorBottom   [UIColor colorWithRed:196.0/255.0 green:060.0/255.0 blue:053.0/255.0 alpha:1.00] // #C43C35

#define kGradientColorWarningTop    [UIColor colorWithRed:252.0/255.0 green:238.0/255.0 blue:193.0/255.0 alpha:1.00] // #FCEEC1
#define kGradientColorWarningBottom [UIColor colorWithRed:238.0/255.0 green:220.0/255.0 blue:148.0/255.0 alpha:1.00] // #EEDC94
#define kTextColorWarning           [UIColor colorWithRed:064.0/255.0 green:064.0/255.0 blue:064.0/255.0 alpha:1.00] // #404040

#define kGradientColorSuccessTop    [UIColor colorWithRed:098.0/255.0 green:196.0/255.0 blue:098.0/255.0 alpha:1.00] // #62C462
#define kGradientColorSuccessBottom [UIColor colorWithRed:087.0/255.0 green:169.0/255.0 blue:087.0/255.0 alpha:1.00] // #57A957

#define kGradientColorInfoTop       [UIColor colorWithRed:091.0/255.0 green:192.0/255.0 blue:222.0/255.0 alpha:1.00] // #5BC0DE
#define kGradientColorInfoBottom    [UIColor colorWithRed:051.0/255.0 green:155.0/255.0 blue:185.0/255.0 alpha:1.00] // #339BB9

#define kBorderColorTop        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50] // alpha:0.10
#define kBorderColorRight      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50] // alpha:0.10
#define kBorderColorBottom     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75] // alpha:0.25
#define kBorderColorLeft       [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50] // alpha:0.10

// Message box

#define kBoxShadowColor     [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25]
#define kHeight             35.0

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
    
    // Updates gradient colors when changing notification type
    switch (_type) {
        case WBNotificationViewTypeError:
            gradientColorTop = kGradientColorErrorTop;
            gradientColorBottom = kGradientColorErrorBottom;
            [messageLabel setTextColor:[UIColor whiteColor]];
            break;
        case WBNotificationViewTypeInfo:
            gradientColorTop = kGradientColorInfoTop;
            gradientColorBottom = kGradientColorInfoBottom;
            [messageLabel setTextColor:[UIColor whiteColor]];
            break;
        case WBNotificationViewTypeSuccess:
            gradientColorTop = kGradientColorSuccessTop;
            gradientColorBottom = kGradientColorSuccessBottom;
            [messageLabel setTextColor:[UIColor whiteColor]];
            break;
        case WBNotificationViewTypeWarning:
            gradientColorTop = kGradientColorWarningTop;
            gradientColorBottom = kGradientColorWarningBottom;
            [messageLabel setTextColor:kTextColorWarning];
            break;
        default:
            gradientColorTop = kGradientColorInfoTop;
            gradientColorBottom = kGradientColorInfoBottom;
            [messageLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)setMessage:(NSString *)message
{
    if (message != nil) {
        _message = message;        
    } else {
        switch (_type) {
            case WBNotificationViewTypeError:
                _message = kMessageError;
                break;
            case WBNotificationViewTypeInfo:
                _message = kMessageInfo;
                break;
            case WBNotificationViewTypeSuccess:
                _message = kMessageSuccess;
                break;
            case WBNotificationViewTypeWarning:
                _message = kMessageWarning;
                break;
            default:
                break;
        }        
    }
 
    [messageLabel setText:_message];
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Add message label
        CGRect messageFrame = CGRectMake(15, 7, frame.size.width - 15, 19);
        messageLabel = [[UILabel alloc] initWithFrame:messageFrame];
        messageLabel.text = self.message;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        [self addSubview:messageLabel];
        
        borderColors = [NSArray arrayWithObjects:
                        (id)kBorderColorTop.CGColor, 
                        (id)kBorderColorRight.CGColor, 
                        (id)kBorderColorBottom.CGColor, 
                        (id)kBorderColorLeft.CGColor, 
                        nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    // Gradient configuration
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(id)gradientColorTop.CGColor, (id)gradientColorBottom.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
 
    CGContextRef context = UIGraphicsGetCurrentContext();
     
    CGContextSaveGState(context);
    {
        // Fill view with gradient
        CGContextAddRect(context, rect);
        // For a rounded rectangle, try:
        // CGContextAddRoundedRect(context, rect, kBorderRadius * 2);
        // CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);        
    }
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace); 

    // Border
    CGContextDrawBorder(context, rect, 1.0, (__bridge CFArrayRef)borderColors);
    
    // Inner box shadow
    CGContextDrawInnerBoxShadow(context, rect, CGSizeMake(0, 2), 1, [kBoxShadowColor CGColor]);    
}

#pragma mark - UI

- (void)performSlideToFrame:(CGRect)newFrame finishingWith:(completionBlock)routine
{
    // To have some atomicity
    if (sliding) return;
        
    sliding = YES;
    
    // If completion block is missing, add default
    if (routine == nil)
        routine = ^(BOOL finished) { sliding = NO; };
        
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationCurveLinear 
                     animations:^{ self.frame = newFrame; } 
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
    _frame.origin.y = 0.0;    
    [self performSlideToFrame:_frame finishingWith:routine];
}

#pragma mark - API

- (id)initWithMessage:(NSString *)aMessage ofType:(WBNotificationViewType)aType
{
    self = [self initWithFrame:CGRectMake(0, -kHeight, 320, kHeight)];
    if (self) {
        self.type = aType;
        self.message = aMessage;
    }
    return self;
}

- (void)slideIn { [self slideInFinishingWith:nil]; }

- (void)slideOut
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = -newFrame.size.height;    
    [self performSlideToFrame:newFrame];
}

- (void)slideInDisappearingIn:(NSTimeInterval)seconds 
{
    [self slideInFinishingWith:^(BOOL finished) {
        sliding = NO;
        [self performSelector:@selector(slideOut) withObject:nil afterDelay:seconds];
    }];
}

@end
