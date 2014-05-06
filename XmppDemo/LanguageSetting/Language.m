//
//  Language.m
//
//
//  Created by paulus.an on 11-10-17.
//  Copyright 2011年 ANHJ. All rights reserved.
//

#import "Language.h"



//#define NSLocalizedStringTest(key, comment) \
//[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@implementation Language  

NSString * const Notification_LANG = @"LANG_IDENTIFICATION";

static NSBundle *bundle = nil;  
static NSString *sLang = @"zh_CN";

+(void)initialize {  
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];  
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];  
    NSString *current = [languages objectAtIndex:0];
/*
    if ( [current isEqualToString:@"zh-Hans"] ) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh_CN" forKey:@"APP_LANG"];
    } else if ( [current isEqualToString:@"zh-Hant"] ) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh_TW" forKey:@"APP_LANG"];
    } else if ([current isEqualToString:@"en"] ) {
        [[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"APP_LANG"];
    }
*/
    [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"APP_LANG"];
    
   [self setLanguage:current];  
    NSString *path = [[ NSBundle mainBundle ] pathForResource:current ofType:@"lproj" ];  
    bundle = [NSBundle bundleWithPath:path];
    for ( id langg in languages)
        NSLog(@"----Langs:%@",langg);
    
}  

+(NSString*)get_sLan {
    NSLog(@"get lan : %@",sLang);
    return sLang;
}


+(void)setLanguage:(NSString *)l {  
    
    sLang = l;
    NSLog(@"preferredLang: %@", l);
}  
  
+(NSString *)get:(NSString *)key alter:(NSString *)alternate {  
    return [bundle localizedStringForKey:key value:alternate table:nil];  
}  

+(NSString*)getLanguageString:(NSString*)keyString commentString:(NSString*)commentStr {
    return [bundle localizedStringForKey:(keyString) value:@"" table:nil];
}

+ (void) loadWording:(NSString *)key comment:(NSString *)comment {
    
    NSString * tmpLANG = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_LANG"];
     
    [[NSBundle bundleWithPath:[[ NSBundle mainBundle ] pathForResource:tmpLANG ofType:@"lproj" ]] localizedStringForKey:(key) value:comment/*@""*/ table:nil];
}

@end 



