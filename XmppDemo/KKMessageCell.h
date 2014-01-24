//
//  KKMessageCell.h
//  XmppDemo
//
//  Created by paul on 12-7-16.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKMessageCell : UITableViewCell


@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UITextView *messageContentView;
@property(nonatomic, retain) UIImageView *bgImageView;


@end
