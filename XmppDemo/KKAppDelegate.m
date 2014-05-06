//
//  KKAppDelegate.m
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import "KKAppDelegate.h"
#import "Statics.h"
#import <AudioToolbox/AudioToolbox.h>
#import "KKChatDelegate.h"
#import "KKMessageDelegate.h"

@implementation KKAppDelegate

@synthesize window = _window;
@synthesize xmppStream;
@synthesize chatDelegate;
@synthesize messageDelegate;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化流
    [self setupStream];

    // Override point for customization after application launch.
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"---applicationDidBecomeActive--start connect");
    [self connect];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setupStream{
    
    //初始化XMPPStream
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    
//    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    if ( !xmppRosterStorage ) {
//        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
//    }
//    if ( !xmppRoster ) {
//        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage ];
//    }
////    xmppRoster.autoFetchRoster = YES;
////    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
//    //}
//    [xmppRoster activate:xmppStream];
//    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
////    [xmppRoster addDelegate:self delegateQueue:dispatch_get_current_queue()];
    
    //    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ( !xmppRosterStorage ) {
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    }
//    if ( !xmppRoster ) {
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage ];

//    }
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [xmppRoster activate:xmppStream];
    //    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_current_queue()];

}

-(void)goOnline{
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"send presence des: %@",presence);

    [[self xmppStream] sendElement:presence];

}

#pragma mark - Alert view
-(void)showAlertView:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)goOffline{
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
    
}
//入口2  -- 连接
-(BOOL)connect{
//    //初始化流
//    [self setupStream];

    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASS];
    NSString *server = [defaults stringForKey:SERVER];
    NSLog(@"curruserid=%@,password=%@,server ip=%@",userId,pass,server);
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (userId == nil || pass == nil ) {
        return NO;
    }
    
    //设置用户
    if ( userId ) {
        [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    }
    //设置服务器
    [xmppStream setHostName:server];
    //密码
    password = pass;
    
    //连接服务器
    NSError *error = nil;
    if (![xmppStream connect:&error]) {
        NSLog(@"cant connect %@  ,%@", server,error);
        return NO;
    }
  
    return YES;

}

-(void)disconnect{
    
    [self goOffline];
    [xmppStream disconnect];
    
}


//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"--xmppStreamDidConnect--/r/n%@/r/n",[sender description]);
    
    [Statics setLoginFlag:NO];
    
    if ( STATE_REQ_RESGIN == [Statics getCurrentRequestType] ) {
        NSLog(@"isConnected:%d, supportsInBandRegistration:%d",
              [xmppStream isConnected],  [xmppStream supportsInBandRegistration] );
        
        if ([xmppStream isConnected] && [xmppStream supportsInBandRegistration]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = [defaults stringForKey:USERID];
            password = [defaults stringForKey:PASS];
            NSError *error ;
//            [xmppStream setMyJID:[XMPPJID jidWithUser:userId domain:SERVER_DOMAIN resource:@""]];
            [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
            if (![xmppStream registerWithPassword:password error:&error]) {
                NSLog(@"---: %@",error.description);
                [self showAlertView:[NSString stringWithFormat:@"%@",error.description]];
            } else {
//                [self dismissModalViewControllerAnimated:YES];
            }
        }
        return;
    }
    
    NSError *error = nil;
    //验证密码
    if ( ![[self xmppStream] authenticateWithPassword:password error:&error] ) {
        NSLog(@"----authenticateWithPassword error == %@",error);
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    NSLog(@"---xmppStreamDidDisconnect error == %@",error);
    [Statics setLoginFlag:NO];
}



//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"\n--xmppStreamDidAuthenticate--\n%@\r%@\n",sender.hostName,[sender description]);
    [Statics setLoginFlag:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginPageClose" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login Success" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReflashMainView" object:nil];

    [self goOnline];
    
    //Voice
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Contact_On" ofType:@"m4a"];
    NSURL *fileUrl  = [NSURL URLWithString:filePath];
    [Statics playVoice:fileUrl];

}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"--didNotAuthenticate-- : %@",[error description]);
    [xmppStream disconnect];
    
    if ( STATE_REQ_LOGIN == [Statics getCurrentRequestType] ) {
        NSString *temp = [error description];
        NSString *jap = @"not-authorized";
        NSRange foundObj=[temp rangeOfString:jap options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginResultError" object:nil];
        }
    }

}
//
//- (void)addUser:(XMPPJID *)jid withNickname:(NSString *)optionalName {
//
//}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    NSLog(@"---didNotRegister---:/n%@",[error description]);
    NSString *temp = [error description];
    NSString *jap = @"409";
    NSRange foundObj=[temp rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(foundObj.length>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Resign_409" object:nil];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"---xmppStreamDidRegister----");
    NSError *error = nil;
    //验证密码
    if ( ![[self xmppStream] authenticateWithPassword:password error:&error] ) {
        NSLog(@"----when registered , authenticateWithPassword error == %@",error);
    }
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
    
}



////收到消息
//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
//    
////    NSLog(@"message = %@", message);
//    
//    NSString *msg = [[message elementForName:@"body"] stringValue];
//    NSString *from = [[message attributeForName:@"from"] stringValue];
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:msg forKey:@"msg"];
//    [dict setObject:from forKey:@"sender"];
//    //消息接收到的时间
//    [dict setObject:[Statics getCurrentTime] forKey:@"time"];
//    
//    //消息委托(这个后面讲)
//    [messageDelegate newMessageReceived:dict];
//    
//
//}
//接受消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"--didReceiveMessage---message is %@",message.toStr);
	// A simple example of inbound message handling.
    
//    //Voice
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Message_Received" ofType:@"m4a"];
//    NSURL *fileUrl  = [NSURL URLWithString:filePath];
//    [Statics playVoice:fileUrl];
    
//	if ([message isChatMessageWithBody])
    if ( [message isChatMessage] )
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];

        NSString *displayName = [user displayName];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSLog(@"from==%@",from);
        
        NSString *body = nil;
        NSString *attachmentType = nil;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        if ( [message isChatAttachmentAudio] || [message isChatAttachmentImage] ) {
            attachmentType = [[message attributeForName:@"attaType"] stringValue];
            body = @"语音/图片";
            [dict setObject:attachmentType forKey:@"attachmentType"];
            [dict setObject:[[message elementForName:@"attachment"] stringValue] forKey:@"attachment"];
        } else {
            body = [[message elementForName:@"body"] stringValue];
            NSLog(@"body==%@",body);
        }
        if ( body ) {
            [dict setObject:body forKey:@"msg"];
        }
        [dict setObject:from forKey:@"sender"];
        //消息接收到的时间
        [dict setObject:[Statics getCurrentTime] forKey:@"time"];
        [self playVibration];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Have a msg" object:message];
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
            //消息委托(这个后面讲)
            [messageDelegate newMessageReceived:dict];
            
		} else {
            
			// We are not active, so use a local notification instead. we could use RemoteAPN too.
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}


//添加好友
#pragma mark 加好友
- (void)XMPPAddFriendSubscribe:(NSString *)friendName
{
//    //从本地取得用户名，密码和服务器地址
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [defaults stringForKey:USERID];
    
    //XMPPHOST 服务器名， 主机名
    XMPPJID *jid = [XMPPJID jidWithString:friendName];
    NSLog(@"added friend name : %@",friendName);
    
//    [self setupStream];
    
    //[presence addAttributeWithName:@"subscription" stringValue:@"好友"];
    [xmppRoster subscribePresenceToUser:jid];
//     [xmppRoster addUser:jid withNickname:nil];
    
}



//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"\n---didReceivePresence---\r\n%@\r\n",presence);
        
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    NSLog(@"current useid=%@, online userid=%@, presenceType=%@",userId,presenceFromUser,presenceType);

    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
        
            //用户列表委托
            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, SERVER_DOMAIN]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托
            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, SERVER_DOMAIN]];
        }
        
        //这里再次加好友
        if ([presenceType isEqualToString:@"subscribe"/*@"subscribed"*/]) {
            XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",[presence from]]];
            [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
        } else if ( [presenceType isEqualToString:@"subscribed"] ) {    //
            
        }
    }

}



//处理加好友
#pragma mark 处理加好友回调,加好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
}

- (void) playVibration {
    //Voice
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"New_Message" ofType:@"m4a"];
    NSURL *fileUrl  = [NSURL URLWithString:filePath];
    [Statics playVoice:fileUrl];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
