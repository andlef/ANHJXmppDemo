//
//  SetLanguageFromNotifications.m
//  FaveSpot
//
//  Created by paulus.an on 11-11-14.
//  Copyright 2011年 ANHJ. All rights reserved.
//

#import "SetLanguageFromNotifications.h"
#import "Language.h"

@implementation SetLanguageFromNotifications
@synthesize sender_;
@synthesize key_;
@synthesize comment_;
@synthesize actionKey_;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initNotiAndSender:(NSString*)key comment:(NSString*)comment actionKey:(ActionKeyType)actKey sender:(id)sender {
    
    self = [super init];
    if (self) {
        // Initialization code here.
        self.key_        = key;
        self.comment_    = comment;
        self.sender_     = sender;
        self.actionKey_  = actKey;
        
        //1.Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLANG:) name:Notification_LANG object:nil];
    }

    return self;
}

- (void) changeLANG:(NSNotification*)note {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_LANG object:nil];
    NSLog(@"--- tmpStr3344 ---: %@ , Des:%@",self.key_,NSLocalizedStringTest([Language get_sLan],self.key_, self.comment_));

    if ( nil==self.sender_) {
        return;
    }
    switch (self.actionKey_) {
        case setText:
//            [self.sender_ setText:NSLocalizedStringTest([Language get_sLan],self.key_, self.comment_) forState:UIControlStateNormal];
            NSLog(@"----------- Warnning!: setText Method Call ---------");
            break;
        case setTitle:
            [self.sender_ setTitle:NSLocalizedStringTest([Language get_sLan],self.key_, self.comment_) forState:UIControlStateNormal];
            break;
        case Text:
            [self.sender_ setText:NSLocalizedStringTest([Language get_sLan],self.key_, self.comment_)];
            break;
        case Title:
            [self.sender_ setTitle:NSLocalizedStringTest([Language get_sLan],self.key_, self.comment_)];
            break;
        case setPlaceholder:
            [self.sender_ setPlaceholder:NSLocalizedStringTest([Language get_sLan], self.key_, self.comment_)];
            break;
        default:
            break;
    }
}

- (void) dealloc {
    NSLog(@"setLanguageFromNotifications dealloc-----------");
    [[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name: Notification_LANG object:nil];
    [self.key_ release];
    [self.sender_ release];
    [self.comment_ release];
    
    [super dealloc];
}

@end
