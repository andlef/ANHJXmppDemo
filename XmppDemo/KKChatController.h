//
//  KKChatController.h
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMessageDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#include "MicView.h"
#import "ASMediaFocusManager.h"

@interface KKChatController : UIViewController<UITableViewDelegate, UITableViewDataSource,  KKMessageDelegate,
                                UIActionSheetDelegate, /*ASMediasFocusDelegate,*/ UINavigationControllerDelegate,
                                    UITextFieldDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate> {
    
    MicView *_micView;
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    float msec;
    NSInteger _sec;
    int wavId;
    NSURL *recordedTmpFile;
    NSString * _destinationString;
    UIImagePickerController * ipc;
                                    
    UIImageView * viewImg;


}
@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UIButton *btnRec;
@property (nonatomic, retain) NSString *chatWithUser;
@property (nonatomic, retain) AVAudioPlayer * avPlayer;
@property(nonatomic,retain) UIImage *picImage;
@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)toRecord:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)sendButton:(id)sender;
- (IBAction)closeButton:(id)sender;

@end
