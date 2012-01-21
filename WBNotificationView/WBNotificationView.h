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

/**
 * WBNotificationView setup
 * TODO:
 * - Support landscape mode
 * @param message: notification's text 
 * @param type: a constant that determines notification's color and default message
 * @return id: a WBNotificationView instance
 * @discussion the view is initially positioned just above (0, 0)
 */
- (id)initWithMessage:(NSString *)message ofType:(WBNotificationViewType)type;
/**
 * Slides the view on screen
 * @discussion will use Core Animation to slide view on screen
 */
- (void)slideIn;
/**
 * Slides the view off screen
 * @discussion will use Core Animation to slide view off screen (just above screen's top border)
 */
- (void)slideOut;
/**
 * Chains a slide in transition to a slide out transition
 * @param seconds: a delay interval between transitions
 */
- (void)slideInDisappearingIn:(NSTimeInterval)seconds;

@end
