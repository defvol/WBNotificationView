//
//  WBNotificationView.h
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WBNotificationViewTypeError,
    WBNotificationViewTypeWarning,
    WBNotificationViewTypeSuccess,
    WBNotificationViewTypeInfo
} WBNotificationViewType;

@class WBNotificationView;

@protocol WBNotificationViewDelegate <NSObject>

@optional
- (void)viewWasClosed:(WBNotificationView *)sender;
- (void)viewDidSlideOut:(WBNotificationView *)sender;

@end

@interface WBNotificationView : UIView

@property (nonatomic) WBNotificationViewType type; 
@property (nonatomic, copy) NSString *message;
@property (nonatomic, weak) id <WBNotificationViewDelegate> delegate;

// Sets message and notification type
// TODO: 
// - Support landscape mode
- (id)initWithMessage:(NSString *)message ofType:(WBNotificationViewType)type;
// Moves the frame on top of the screen
- (void)slideIn;
// Moves the frame just above the screen
- (void)slideOut;
// Performs a slide-in/slide-out delayed transition
- (void)slideInDisappearingIn:(NSTimeInterval)seconds;

@end
