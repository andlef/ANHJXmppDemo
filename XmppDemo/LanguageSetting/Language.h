//
//  Language.h
//
//
//  Created by paulus.an on 11-10-17.
//  Copyright 2011年 ANHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//static NSString * sLan = @"zh-Hant";

#define LANG_FILE_NAME @"Localization"

extern NSString * const Notification_LANG;

#define NSLocalizedStringTest(lan, key, comment) \
[[NSBundle bundleWithPath:[[ NSBundle mainBundle ] pathForResource:lan ofType:@"lproj" ]] localizedStringForKey:(key) value:@"" table:LANG_FILE_NAME]

typedef enum {
    setTitle,
    setText,
    Title,
    Text,
    setPlaceholder,
    
} ActionKeyType;


@interface Language : NSObject {
    
}

+(void) loadWording:(NSString*)key comment:(NSString*)comment;

+(NSString*)get_sLan;
+(void)setLanguage:(NSString *)l;

@end
