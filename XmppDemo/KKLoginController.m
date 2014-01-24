//
//  KKLoginController.m
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import "KKLoginController.h"
#import "KKAppDelegate.h"
#import "Statics.h"

@interface KKLoginController ()

@end

@implementation KKLoginController
@synthesize userTextField;
@synthesize passTextField;
@synthesize serverTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(KKAppDelegate *)appDelegate{
    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if( [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 ) {
        self.edgesForExtendedLayout = UIRectEdgeLeft;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
}

- (void)viewDidUnload
{
    [self setUserTextField:nil];
    [self setPassTextField:nil];
    [self setServerTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}



- (IBAction)LoginButton:(id)sender {
    
    if ([self validateWithUser:userTextField.text andPass:passTextField.text andServer:serverTextField.text]) {
        [Statics setCurrentRequestType:STATE_REQ_LOGIN];
        NSString * userStr = [NSString stringWithFormat:@"%@@%@",userTextField.text,SERVER_DOMAIN];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userStr forKey:USERID];
        [defaults setObject:self.passTextField.text forKey:PASS];
        [defaults setObject:self.serverTextField.text forKey:SERVER];
        [defaults synchronize];
        
        [self dismissModalViewControllerAnimated:YES];

        //每次返回这个界面的时候，尝试一次登陆
        NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        //入口--1 登陆
        if (login) {
            if ([[self appDelegate] connect]) {
                NSLog(@"show buddy list，登陆成功");
            }
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置账号" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
}

- (IBAction)closeButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)validateWithUser:(NSString *)userText andPass:(NSString *)passText andServer:(NSString *)serverText{
    
    if (userText.length > 0 && passText.length > 0 && serverText.length > 0) {
        return YES;
    }
    
    return NO;
}

@end
