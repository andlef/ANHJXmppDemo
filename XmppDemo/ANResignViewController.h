//
//  ANResignViewController.h
//  XmppDemo
//
//  Created by paulus.an on 14-1-8.
//  Copyright (c) 2014年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANResignViewController : UIViewController {
    
}

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UITextField *passwd;
- (IBAction)cancelResign:(id)sender;

- (IBAction)submitResign:(id)sender;


@end
