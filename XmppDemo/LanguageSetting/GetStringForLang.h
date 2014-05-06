//
//  GetStringForLang.h
//  
//  语言设置
//  Created by paulus.an on 11-10-21.
//  Copyright 2011年 ANHJ. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Language.h"

@class SetLanguageFromNotifications;

@interface GetStringForLang : NSObject {
    
    SetLanguageFromNotifications * setLangFromNoti;
    
}

- (NSString *) getStrFromGetStringForLang:(NSString*)key comment:(NSString*)comment sender:(id)sender actionKey:(ActionKeyType)actionKey;

- (NSString*) getString:(NSString*)key;

@end
