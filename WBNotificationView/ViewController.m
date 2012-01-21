//
//  ViewController.m
//  WBNotificationView
//
//  Created by Rodolfo Wilhelmy on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController 
{
    BOOL toggleOn;
    WBNotificationView *notificationView;
}

@synthesize warningButton;
@synthesize errorButton;
@synthesize successButton;
@synthesize infoButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    notificationView = [[WBNotificationView alloc] initWithMessage:nil ofType:WBNotificationViewTypeWarning];
    [notificationView setDelegate:self];
    [self.view addSubview:notificationView];
}

- (void)viewDidUnload
{
    [self setWarningButton:nil];
    [self setErrorButton:nil];
    [self setSuccessButton:nil];
    [self setInfoButton:nil];
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
    WBNotificationViewType type = WBNotificationViewTypeInfo;
    
    if (sender == warningButton) {
        type = WBNotificationViewTypeWarning;
    } else if (sender == errorButton) {
        type = WBNotificationViewTypeError;
    } else if (sender == successButton) {
        type = WBNotificationViewTypeSuccess;
    } else if (sender == infoButton) {
        type = WBNotificationViewTypeInfo;
    }
    
    [notificationView setType:type];
    [notificationView setMessage:nil]; // Set to default
    
    // Switch toggle on and off
    if (toggleOn ^= 1) {
        [notificationView slideIn];
    } else {
        [notificationView slideOut];
    }
}

#pragma mark - WBNotificationViewDelegate

- (void)viewWasClosed:(WBNotificationView *)sender
{
    NSLog(@"View was closed");
    toggleOn = NO;
}

- (void)viewDidSlideOut:(WBNotificationView *)sender
{
    NSLog(@"View did slide out");
}

@end
