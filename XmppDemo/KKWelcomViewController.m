//
//  KKWelcomViewController.m
//  XmppDemo
//
//  Created by paulus.an on 13-12-31.
//  Copyright (c) 2013年 ANHJ&Paul. All rights reserved.
//

#import "KKWelcomViewController.h"
#import "KKAppDelegate.h"

@interface KKWelcomViewController ()

@end

@implementation KKWelcomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    KKAppDelegate *delegate = (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate connect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
