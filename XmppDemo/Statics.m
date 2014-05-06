//
//  Statics.m
//  XmppDemo
//
//  Created by paul on 12-7-13.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import "Statics.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation Statics

-(id)init{
    self = [super init];
    if(nil!=self){
//        currentRequestType = STATE_REQ_START;
    }
    return self;
}

+(NSString *)getCurrentTime{
    
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [dateFormatter stringFromDate:nowUTC];
    
}

+(void)setLoginFlag:(BOOL)isLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isLogin]  forKey:@"isLogin"];
    [defaults synchronize];
}

+(BOOL)isLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:@"isLogin"] boolValue];    
}

+(void)setCurrentRequestType:(RequestTypeState)reqType {
    currentRequestType = reqType;
}

+(RequestTypeState)getCurrentRequestType {
    NSLog(@"getCurrentRequestType = %d",currentRequestType);
    return currentRequestType;
}

+(void)playVoice:(NSURL*)url {
    //Voice
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    AudioServicesPlaySystemSound(soundId);
}




@end
