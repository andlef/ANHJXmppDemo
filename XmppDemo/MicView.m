//
//  MicView.m
//  NFBC_Fabao
//
//  Created by paulus on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MicView.h"

@implementation MicView

@synthesize rootView;

-(void)generate{
    self.alpha=0.0;
    self.frame=CGRectMake(0, 0, 120, 120);
    self.center=CGPointMake(rootView.bounds.size.width/2, rootView.bounds.size.height/2-30);
    [rootView addSubview:self];
    
    
        //录音底图
    UIImageView *backView=[[UIImageView alloc] init];
    backView.frame=self.bounds;
    backView.image=[UIImage imageNamed:@"录音底图"];
    backView.contentMode=UIViewContentModeScaleAspectFit;
    
    
        //    UIView *backView=[[UIView alloc] init];
        //    backView.frame=self.bounds;
        //    backView.backgroundColor=[UIColor blackColor];
        //    backView.alpha=0.5;
    
        //        //我们随便找个view来表示音量
        //    valueView=[[UIView alloc] init];
        //    valueView.backgroundColor=[UIColor whiteColor];
        //    [self addSubview:valueView];
    
    labSec = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
    labSec.text = @"正在录音－60";
    labSec.textAlignment=UITextAlignmentCenter;
    labSec.textColor=[UIColor whiteColor];
    labSec.backgroundColor=[UIColor clearColor];
    [backView addSubview:labSec];
    
    UIImageView *micView=[[UIImageView alloc] init];
    micView.frame=CGRectMake(0, 0, 26, 42);
    micView.image=[UIImage imageNamed:@"麦克风"];
    micView.contentMode=UIViewContentModeScaleAspectFit;
    [backView addSubview:micView];
    micView.center=backView.center;
    
    [self addSubview:backView];
    
}

-(void)show{
    labSec.text = @"正在录音－60";
    [rootView bringSubviewToFront:self];
    self.alpha=1.0;
}

-(void)hide{
    self.alpha=0.0;
}

-(void)changeValue:(NSString*)strSec msec:(NSString*)strMSec{

    labSec.text=[NSString stringWithFormat:@"%@:%@",strSec,strMSec];
    
//    labSec.text = [NSString stringWithFormat:@"正在录音－%d",value];
    
}

-(void)dealloc{

}


@end
