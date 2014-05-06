//
//  ANResignViewController.m
//  XmppDemo
//
//  Created by paulus.an on 14-1-8.
//  Copyright (c) 2014年 ANHJ&Paul. All rights reserved.
//

#import "ANResignViewController.h"
#import "Statics.h"
#import "MBProgressHUD.h"
#import "KKAppDelegate.h"

@interface ANResignViewController ()

@end

@implementation ANResignViewController

@synthesize phoneNumber, passwd, nickName;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignResult409)
                                                 name:@"Resign_409"
                                               object:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeText;
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍等";
    
}

- (void) resignResult409 {
    [self showHUD:@"用户名已存在"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(KKAppDelegate *)appDelegate{
    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(BOOL)allInformationReady{
    if ( 0 == [self.phoneNumber.text length] && 0 == [self.passwd.text length] ) {
        [self showHUD:@"请输入用户名和密码"];
        return NO;
    }
    [[[self appDelegate] xmppStream] setHostName:SERVER_DOMAIN];
    return YES;
}

- (IBAction)cancelResign:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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

- (IBAction)submitResign:(id)sender {
    if (![self allInformationReady]) {
        return;
    }
    
    if ( 1 > [phoneNumber.text length] ) {
        [self showHUD:@"请输入手机号码"];
        return;
    } else if ( 1 > [passwd.text length] ) {
        [self showHUD:@"请输入密码"];
        return;
    }
    
    [Statics setCurrentRequestType:STATE_REQ_RESGIN];
    
    NSString * tmpstr = [NSString stringWithFormat:@"%@@%@",self.phoneNumber.text, SERVER_DOMAIN];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tmpstr forKey:USERID];
    [defaults setObject:self.passwd.text forKey:PASS];
    [defaults setObject:SERVER_DOMAIN forKey:SERVER];
    [defaults synchronize];
    
    if (![[self appDelegate].xmppStream isDisconnected]) {
        NSLog(@"---connected!!!");
        
    } else {
        //    [[self appDelegate].xmppStream setMyJID:[XMPPJID jidWithString:tmpstr]];
        [[self appDelegate].xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"paul@%@",SERVER_DOMAIN]]];
        [[self appDelegate].xmppStream setHostName:@"192.168.9.177"];

        NSError *error = nil;
        if (![[self appDelegate].xmppStream connect:&error]) {
            NSLog(@"cant connect %@  ,%@", SERVER_DOMAIN,error);
        }
    }
    

    
//    NSLog(@"isConnected:%d, supportsInBandRegistration:%d", [[[self appDelegate] xmppStream] isConnected],  [[[self appDelegate]xmppStream] supportsInBandRegistration] );
//    
//    if ([[[self appDelegate] xmppStream] isConnected] && [[[self appDelegate]xmppStream] supportsInBandRegistration]) {
//        NSError *error ;
//        [[self appDelegate].xmppStream setMyJID:[XMPPJID jidWithUser:self.phoneNumber.text domain:SERVER_DOMAIN resource:@"XMPPIOS"]];
//        //        [[self appDelegate]setIsRegistration:YES];
//        if (![[self appDelegate].xmppStream registerWithPassword:self.passwd.text error:&error]) {
//            NSLog(@"---: %@",error.description);
//            [[self appDelegate] showAlertView:[NSString stringWithFormat:@"%@",error.description]];
//        } else {
//            [self dismissModalViewControllerAnimated:YES];
//        }
//    }
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self submitResign:nil];
    [textField resignFirstResponder];
    
    return YES;
}


@end
