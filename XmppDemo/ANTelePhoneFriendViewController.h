//
//  ANTelePhoneFriendViewController.h
//  XmppDemo
//
//  Created by paulus.an on 14-1-17.
//  Copyright (c) 2014年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTelePhoneFriendViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* personArray;
    
    NSMutableArray * friendAndTel;
    
    NSInteger numBoth;
}

@property (nonatomic, strong) NSArray * myFriend;
//@property (nonatomic, readwrite) NSInteger numBoth;

@end
