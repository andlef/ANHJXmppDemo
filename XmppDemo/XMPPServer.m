//
//  XMPPServer.m
//  XmppDemo
//
//  Created by paul on 12-7-13.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import "XMPPServer.h"
#import "XMPPPresence.h"
#import "XMPPJID.h"
#import "Statics.h"

static XMPPServer *server = nil;

@implementation XMPPServer

//单例
+(XMPPServer *)sharedServer{
    
    @synchronized(self){
        if (server == nil) {
            server = [[self alloc] init];
        }
        
    }
    
    return server;
    
}

+(id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        
        if (server == nil) {
            server = [super allocWithZone:zone];
            
            return server;
        }
        
    }
    return nil;
    
}

-(void)setupStream{
    
    self.xmppStream = [[XMPPStream alloc] init];
    //在主线程中运行
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

//取得在线人员
-(void)getOnline{
    
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
}

-(void)getOffline{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
}

-(BOOL)connect{
    
    NSLog(@"11111");
    
    [self setupStream];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *jabberId  = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASS];
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jabberId == nil || password == nil) {
        return NO;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jabberId]];
    [self.xmppStream setHostName:[defaults stringForKey:SERVER]];
    password = pass;
    
    NSError *error = nil;
    if (![self.xmppStream connect:&error]) {
        
        NSString *errorStr = [NSString stringWithFormat:@"不能连接服务器 %@",error];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    
    return YES;
    
}

-(void)disconnect{
    
    [self getOffline];
    [self.xmppStream disconnect];
    
}




@end
