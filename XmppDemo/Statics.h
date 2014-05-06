//
//  Statics.h
//  XmppDemo
//
//  Created by paul on 12-7-13.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *USERID = @"userId";
static NSString *PASS= @"pass";
static NSString *SERVER = @"server";
static NSString *SERVER_DOMAIN = @"xmppserver";//@"192.168.1.69"; //@"dms"
// Define the various states we'll use to track our progress
enum RequestTypeState
{
    STATE_REQ_START,
	STATE_REQ_RESGIN,
	STATE_REQ_LOGIN,
    STATE_REQ_ADDFRIEND,
    STATE_REQ_LOGOUT,
};
typedef enum RequestTypeState RequestTypeState;

static  RequestTypeState currentRequestType;

@interface Statics : NSObject {
    @private
//    RequestTypeState currentRequestType;
}

+(NSString *)getCurrentTime;

+(BOOL)isLogin;
+(void)setLoginFlag:(BOOL)isLogin;
+(void)setCurrentRequestType:(RequestTypeState)reqType;
+(RequestTypeState)getCurrentRequestType;
+(void)playVoice:(NSURL*)url;

@end
