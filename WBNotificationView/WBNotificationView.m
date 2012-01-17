//
//  WBNotificationView.m
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WBNotificationView.h"

// Default notification messages
#define kDefaultMessageError     @"Oh snap! Change this and that and try again."
#define kDefaultMessageWarning   @"Holy guacamole! Best check yo self, you’re not looking too good."
#define kDefaultMessageSuccess   @"Well done! You successfully read this alert message."
#define kDefaultMessageInfo      @"Heads up! This is an alert that needs your attention, but it’s not a huge priority just yet."

// Default colors
#define kDefaultColorError      [UIColor colorWithRed:196.0/255.0 green:060.0/255.0 blue:053.0/255.0 alpha:1.0] // #C43C35
#define kDefaultColorWarning    [UIColor colorWithRed:238.0/255.0 green:220.0/255.0 blue:148.0/255.0 alpha:1.0] // #EEDC94
#define kDefaultColorSuccess    [UIColor colorWithRed:087.0/255.0 green:169.0/255.0 blue:087.0/255.0 alpha:1.0] // #57A957
#define kDefaultColorInfo       [UIColor colorWithRed:051.0/255.0 green:155.0/255.0 blue:185.0/255.0 alpha:1.0] // #339BB9

// Style
#define kDefaultHeight          40.0
#define kDefaultPadding         10.0
#define kMessageLabelViewTag    1001

// Goodies
#define INVERT_SIGN(x)  ~x + 1

typedef void (^completionBlock)(BOOL);

@implementation WBNotificationView
{
    BOOL sliding;
}

@synthesize type;

#pragma mark - Style

- (UIColor *)backgroundColorForType:(WBNotificationViewType)_type
{
    switch (_type) {
        case WBNotificationViewTypeError:
            return kDefaultColorError;
        case WBNotificationViewTypeInfo:
            return kDefaultColorInfo;
        case WBNotificationViewTypeSuccess:
            return kDefaultColorSuccess;
        case WBNotificationViewTypeWarning:
            return kDefaultColorWarning;
        default:
            return kDefaultColorInfo;
    }
}

- (void)addLabelWithMessage:(NSString *)message;
{
    CGRect _frame = CGRectMake(kDefaultPadding, 0, self.frame.size.width - kDefaultPadding * 2, self.frame.size.height);
    _frame.size.height = kDefaultHeight / 2.0;
    _frame.origin.y = kDefaultHeight / 2.0 - _frame.size.height / 2.0;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:_frame];
    messageLabel.text = message;
    messageLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.tag = kMessageLabelViewTag;
    
    [self addSubview:messageLabel];
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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

- (void)performSlideToFrame:(CGRect)newFrame 
{
    [self performSlideToFrame:newFrame finishingWith:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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

- (id)initWithMessage:(NSString *)_message ofType:(WBNotificationViewType)_type
{
    // TODO: support landscape mode
    self = [self initWithFrame:CGRectMake(0, -kDefaultHeight, 320, kDefaultHeight)];
    if (self) {
        [self addLabelWithMessage:_message];
        self.type = _type;        
        [self setBackgroundColor:[self backgroundColorForType:_type]];
    }
    return self;
}

- (void)slideIn
{
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
