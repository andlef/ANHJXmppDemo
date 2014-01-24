//
//  KKChatDelegate.h
//  XmppDemo
//
//  Created by paul on 12-7-13.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKChatDelegate <NSObject>

-(void)newBuddyOnline:(NSString *)buddyName;
-(void)buddyWentOffline:(NSString *)buddyName;
-(void)didDisconnect;

@end
