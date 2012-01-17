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

@interface WBNotificationView : UIView

@property WBNotificationViewType type; 

- (id)initWithMessage:(NSString *)message ofType:(WBNotificationViewType)type;
- (void)slideIn;
- (void)slideOut;
- (void)slideInDisappearingIn:(NSTimeInterval)seconds;

@end
