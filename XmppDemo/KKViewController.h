//
//  KKViewController.h
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Statics.h"
#import "KKChatDelegate.h"
#import "GetStringForLang.h"

@interface KKViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,KKChatDelegate> {
    GetStringForLang  *   getString4Lang;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginAndLogout;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *reginAndAddFriend;
@property (strong, nonatomic) IBOutlet UIButton *telePhoneBut;
@property (strong, nonatomic) IBOutlet UIButton *settingLangBut;

- (IBAction)actResignAndAddFriend:(id)sender;

- (IBAction)Account:(id)sender;
- (IBAction)telePhoneBook:(id)sender;
- (IBAction)settingLang:(id)sender;
@end
