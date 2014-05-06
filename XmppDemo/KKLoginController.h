//
//  KKLoginController.h
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface KKLoginController : UITableViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    MBProgressHUD * HUD;
}

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
@property (strong, nonatomic) IBOutlet UITextField *serverTextField;
- (IBAction)LoginButton:(id)sender;
- (IBAction)closeButton:(id)sender;

@end
