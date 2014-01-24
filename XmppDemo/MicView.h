//
//  MicView.h
//  NFBC_Fabao
//
//  Created by paulus on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MicView : UIView {
    UIView *rootView;
    UIView *valueView;
    
    UILabel * labSec;
    
}
@property(nonatomic,retain) UIView *rootView;
-(void)generate;
-(void)show;
-(void)hide;
-(void)changeValue:(NSString*)strSec msec:(NSString*)strMSec;
@end
