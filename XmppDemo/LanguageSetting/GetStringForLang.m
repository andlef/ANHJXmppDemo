//
//  GetStringForLang.m
//
//
//  Created by paulus.an on 11-10-21.
//  Copyright 2011年 ANHJ. All rights reserved.
//

#import "GetStringForLang.h"
#import "SetLanguageFromNotifications.h"

@implementation GetStringForLang

- (id)init
{
    self = [super init];
    if (self) {}
    
    return self;
}

- (NSString*) getStrFromGetStringForLang:(NSString *)key comment:(NSString *)comment sender:(id)sender actionKey:(ActionKeyType)actKey {
    
    //Establish ObserverInstance for id's string.
    setLangFromNoti = [[SetLanguageFromNotifications alloc] initNotiAndSender:key comment:comment actionKey:actKey sender:sender];
    
//    //1.Add Observer
//    [nc_ addObserver:self selector:@selector(changeLANG:) name:Notification_LANG object:nil];
    
    //2.Return Localized String
    NSString * tmpStr = NSLocalizedStringTest([Language get_sLan], key, comment);
    NSLog(@"--- tmpStr ---: %@",tmpStr);
    return tmpStr;
}

- (NSString*) getString:(NSString*)key {
    NSString * tmpStr = NSLocalizedStringTest([Language get_sLan], key, comment);
    NSLog(@"--- tmpStr ---: %@",tmpStr);
    return tmpStr;
}

- (void) dealloc {
    [setLangFromNoti release];
    [super dealloc];
}

@end
