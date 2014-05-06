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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginResError)
                                                 name:@"LoginResultError"
                                               object:nil];
    //LoginPageClose
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closePage)
                                                 name:@"LoginPageClose"
                                               object:nil];
    
    if( [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 ) {
        self.edgesForExtendedLayout = UIRectEdgeLeft;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeText;
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    //设置对话框文字
    HUD.labelText = @"请稍等";
}

- (void) loginResError {
    [self showHUD:@"用户名或密码错误"];
}

- (void) closePage {
    [self dismissModalViewControllerAnimated:YES];
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

- (void) showHUD:(NSString*)msg {
    
    HUD.labelText = msg;
    
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    } completionBlock:^{
        //操作执行完后取消对话框
        //        [HUD removeFromSuperview];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self LoginButton:nil];
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
        
//        [self dismissModalViewControllerAnimated:YES];

        //每次返回这个界面的时候，尝试一次登录
        NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        //入口--1 登录
        if (login) {
            if ([[self appDelegate] connect]) {
                NSLog(@"show buddy list，登录成功");
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
    
    if ( 0 < userText.length && 0 < passText.length  && 0 < serverText.length ) {
        return YES;
    }
    
    if ( 0 == userText.length ) {
        [self showHUD:@"请输入手机号码"];
    } else if ( 0 == passText.length ) {
        [self showHUD:@"请输入密码"];
    }
    return NO;
}

// return NO to not change text
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ( [string isEqualToString:@""] ) {
        return YES;
    }
    
    if ( 10 == textField.tag && 11 <= textField.text.length ) {
        [self showHUD:@"用户名最长不能超过11位"];
        return NO;
    }
    if ( 11 == textField.tag && 6 <= textField.text.length) {
        [self showHUD:@"密码最长不能超过6位"];
        return NO;
    }
    return YES;
}


@end
