//
//  ANTelePhoneFriendViewController.h
//  XmppDemo
//
//  Created by paulus.an on 14-1-17.
//  Copyright (c) 2014年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTelePhoneFriendViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray * personArray;       //电话条目
    NSMutableArray * allPhoneNumber;    //所有电话号码(不包括friendAndTel)
    NSMutableArray * friendAndTel;      //既是好友号码，又是本地通讯录号码
    
    NSMutableArray * allNameArray;      //所有联系人(不包括friendNameArray)
    NSMutableArray * friendNameArray;   //既是好友，又是本地通讯录 的联系人
    
    NSInteger numBoth;
    NSInteger numOthers;
}

@property (nonatomic, strong) NSArray * myFriend;
//@property (nonatomic, readwrite) NSInteger numBoth;

@end
