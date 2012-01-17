//
//  ViewController.m
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "WBNotificationView.h"

@implementation ViewController 
{
    BOOL toggleOn;
    WBNotificationView *notificationView;
}

@synthesize toggleButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    notificationView = [[WBNotificationView alloc] initWithMessage:@"Something's not working" ofType:WBNotificationViewTypeError];
    [self.view addSubview:notificationView];
}

- (void)viewDidUnload
{
    [self setToggleButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [notificationView slideInDisappearingIn:3.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)shouldToggle:(id)sender 
{
    // Switch toggle on and off
    if (toggleOn ^= 1) {
        [notificationView slideIn];
    } else {
        [notificationView slideOut];
    }
}

@end
