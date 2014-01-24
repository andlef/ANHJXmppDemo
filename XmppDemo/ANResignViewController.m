//
//  ANResignViewController.m
//  XmppDemo
//
//  Created by paulus.an on 14-1-8.
//  Copyright (c) 2014年 ANHJ&Paul. All rights reserved.
//

#import "ANResignViewController.h"
#import "Statics.h"
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
    if ( self.phoneNumber.text && self.passwd.text ) {
        [[[self appDelegate] xmppStream] setHostName:SERVER_DOMAIN];
        return YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息不完整" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];    return NO;
}

- (IBAction)cancelResign:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)submitResign:(id)sender {
    if (![self allInformationReady]) {
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
        [[self appDelegate].xmppStream setHostName:@"192.168.21.177"];

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


@end
