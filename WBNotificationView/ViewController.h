//
//  ViewController.h
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBNotificationView.h"

@interface ViewController : UIViewController <WBNotificationViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *warningButton;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UIButton *successButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

- (IBAction)shouldToggle:(id)sender;

@end
