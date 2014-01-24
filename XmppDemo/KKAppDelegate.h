//
//  KKAppDelegate.h
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "LibIDN.h"

@interface KKAppDelegate : UIResponder <UIApplicationDelegate>{
    
    XMPPStream *xmppStream;
    NSString *password;

}

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, readonly)XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
//@property (nonatomic, strong, readonly) XMPPRoster  xmppRosteractivate

@property(nonatomic, retain)id chatDelegate;
@property(nonatomic, retain)id messageDelegate;

-(void)showAlertView:(NSString *)message;

//是否连接
-(BOOL)connect;
//断开连接
-(void)disconnect;

//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;
//加好友
- (void)XMPPAddFriendSubscribe:(NSString *)friendName;

@end
