//
//  SetLanguageFromNotifications.h
//
//
//  Created by paulus.an on 11-11-14.
//  Copyright 2011年 ANHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Language.h"

@interface SetLanguageFromNotifications : NSObject {

    id                  sender_;
    ActionKeyType       actionKey_;
    NSString        *   key_;
    NSString        *   comment_;
}

@property (nonatomic, retain)       id  sender_;
@property (nonatomic, copy)         NSString                *  key_;
@property (nonatomic, copy)         NSString                *  comment_;
@property (nonatomic, readwrite)    ActionKeyType   actionKey_;

- (id) initNotiAndSender:(NSString*)key comment:(NSString*)comment actionKey:(ActionKeyType)actKey sender:(id)sender;
- (void) changeLANG:(NSNotification*)note;


@end
