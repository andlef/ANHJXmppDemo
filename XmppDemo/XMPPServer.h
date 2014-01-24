//
//  XMPPServer.h
//  XmppDemo
//
//  Created by paul on 12-7-13.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPStream.h"
#import "XMPP.h"

@protocol XMPPServerDelegate <NSObject>

-(void)setupStream;
-(void)getOnline;
-(void)getOffline;

@end

@interface XMPPServer : NSObject<XMPPServerDelegate>{
    
    NSString *password;
    BOOL isOpen;
}

@property(nonatomic, retain)XMPPStream *xmppStream;

+(XMPPServer *)sharedServer;

-(BOOL)connect;

-(void)disconnect;


@end
