//
//  KKChatController.m
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import "KKChatController.h"
#import "KKAppDelegate.h"
#import "Statics.h"
#import "KKMessageCell.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "SJAvatarBrowser.h"

#define padding 30

static CGFloat const kMaxAngle = 0.1;
static CGFloat const kMaxOffset = 15;


@interface KKChatController (){
    
    NSMutableArray *messages;
    
}
    @property (nonatomic, retain) NSData * aiData;
    @property (nonatomic, retain) NSData * imgData;


@end

@implementation KKChatController
@synthesize tView;
@synthesize messageTextField, btnRec;
@synthesize chatWithUser;
@synthesize aiData, imgData;
@synthesize avPlayer,mediaFocusManager;


- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

+ (float)randomFloatBetween:(float)smallNumber andMax:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void)addSomeRandomTransformOnThumbnailViews:(UIImageView*)imageView
{
//    for(UIView *view in self.imageViews)
//    {
        UIView * view = imageView;
        CGFloat angle;
        NSInteger offsetX;
        NSInteger offsetY;
        
        angle = [KKChatController randomFloatBetween:-kMaxAngle andMax:kMaxAngle];
        offsetX = (NSInteger)[KKChatController randomFloatBetween:-kMaxOffset andMax:kMaxOffset];
        offsetY = (NSInteger)[KKChatController randomFloatBetween:-kMaxOffset andMax:kMaxOffset];
        view.transform = CGAffineTransformMakeRotation(angle);
        view.center = CGPointMake(view.center.x + offsetX, view.center.y + offsetY);
        
        // This is going to avoid crispy edges.
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.tView.delegate = self;
    self.tView.dataSource = self;
    self.tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    messages = [NSMutableArray array];
    messageTextField.delegate = self;
    [messageTextField becomeFirstResponder];
    
    KKAppDelegate *del = [self appDelegate];
    del.messageDelegate = self;
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //麦克风录制时间
    _micView = [[MicView alloc] init];
    _micView.rootView = self.view;
    [_micView generate];
    _destinationString = [[NSString alloc] initWithString: [[self documentsPath]
                                                            stringByAppendingPathComponent:[NSString stringWithFormat: @"_%d.%@", 1000, @"wav"/*@"caf"*/]]];
    UIButton *btnRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRecord.frame=CGRectMake(0, 90, 120, 30);
    [btnRecord setTitle:@"确定" forState:UIControlStateNormal];
    [btnRecord setBackgroundColor:[UIColor clearColor]];
    [btnRecord setTitle:@"确定" forState:UIControlStateHighlighted];
    btnRecord.titleLabel.textColor=[UIColor whiteColor];
    [btnRecord addTarget:self action:@selector(btnRecordClick) forControlEvents:UIControlEventTouchUpInside];
    [_micView addSubview:btnRecord];
    
    
    if(self.scrollView){
        self.scrollView.contentSize = self.view.bounds.size;
    }
    UIImageView *splitView = [[UIImageView alloc] init];
    splitView.frame=CGRectMake(0, 89, _micView.frame.size.width, 2);
    splitView.image=[UIImage imageNamed:@"录音分隔线"];
    splitView.contentMode=UIViewContentModeScaleToFill;
    [_micView addSubview:splitView];
    
    [self removeRecFile];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    [self preRecord];
    
//    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
//    self.mediaFocusManager.delegate = self;
    viewImg = [[UIImageView alloc] initWithFrame:CGRectMake(190, 20, 110, 80)];
    viewImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClickedImg:)];
    [viewImg addGestureRecognizer:singleTap];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidUnload
{
    [self setTView:nil];
    [self setMessageTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"msgCell";
    
    KKMessageCell *cell =(KKMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[KKMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    
    //发送者
    NSString *sender = [dict objectForKey:@"sender"];
    //消息
    NSString *message = [dict objectForKey:@"msg"];
    NSLog(@"message=%@",message);
    //时间
    NSString *time = [dict objectForKey:@"time"];
    
    CGSize textSize = {260.0 ,10000.0};
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:textSize
                          lineBreakMode:UILineBreakModeWordWrap];
    
    size.width +=(padding/2);
    [cell setTranslatesAutoresizingMaskIntoConstraints:YES];
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = YES;
    
    if ( indexPath.row%2) {
        [cell setBackgroundColor:[UIColor yellowColor]];
    } else {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    UIImage *bgImage = nil;
    
    //发送消息
    if ([sender isEqualToString:@"you"]) {
        UIButton * btnPlayOrShow = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect leftFrame = CGRectMake(padding, padding/2, size.width, size.height+5);
        if ( [[dict objectForKey:@"attachmentType"] isEqualToString:@"audio"] ) {
            [btnPlayOrShow setTitle:@"playAudio" forState:UIControlStateNormal];
            [btnPlayOrShow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnPlayOrShow addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
            [btnPlayOrShow setFrame:leftFrame];
            [cell.contentView addSubview:btnPlayOrShow];
            
//            aiData = [NSData dataWithBase64EncodedString:[dict objectForKey:@"attachment"]];
        } else if ( [[dict objectForKey:@"attachmentType"] isEqualToString:@"image"] ) {
            [btnPlayOrShow setTitle:@"showImage" forState:UIControlStateNormal];
            [btnPlayOrShow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnPlayOrShow addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
            [btnPlayOrShow setFrame:leftFrame];
            [cell.contentView addSubview:btnPlayOrShow];
        } else {
            //背景图
            bgImage = [[UIImage imageNamed:@"BlueBubble2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            [cell.messageContentView setFrame:CGRectMake(padding, padding/2, size.width, size.height+5)];
        }
        
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                              cell.messageContentView.frame.origin.y - padding/2 + 5,
                                              size.width + padding, size.height + padding)];
        
    }else {

        CGRect rightFrame = CGRectMake(200, 20+10, 90, 40);
        [cell.messageContentView setFrame:CGRectMake(rightFrame.origin.x-90, rightFrame.origin.y, rightFrame.size.width+10, rightFrame.size.height)];
        UIButton * btnPlayOrShow = [[UIButton alloc] initWithFrame:rightFrame];
        if ( [[dict objectForKey:@"attachmentType"] isEqualToString:@"audio"] ) {
            [btnPlayOrShow setTitle:@"点击播放" forState:UIControlStateNormal];
            [btnPlayOrShow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnPlayOrShow setEnabled:YES];
            [btnPlayOrShow setBackgroundColor:[UIColor greenColor]];
            [btnPlayOrShow addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnPlayOrShow];
            
            NSString * base64Str = [dict objectForKey:@"attachment"];
            aiData = [base64Str base64DecodedData];
            [self removeRecFile];
            
        } else if ( [[dict objectForKey:@"attachmentType"] isEqualToString:@"image"] ) {
            CGRect rightFrame = CGRectMake(190, 20, 110, 80);
            NSString * base64Str = [dict objectForKey:@"attachment"];
            NSData * dataTmp = [base64Str base64DecodedData];
            UIImage * imgTmp = [UIImage imageWithData:dataTmp];
            
//            [btnPlayOrShow setFrame:rightFrame];
//            [btnPlayOrShow setBackgroundImage:imgTmp forState:UIControlStateNormal];
//            [btnPlayOrShow addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
//            [btnPlayOrShow setBackgroundColor:[UIColor greenColor]];
//            [btnPlayOrShow setFrame:rightFrame];
            
            viewImg.image = imgTmp;
//            // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
//            [self.mediaFocusManager installOnView:viewImg];
////            [cell.contentView addSubview:btnPlayOrShow];
//            [self addSomeRandomTransformOnThumbnailViews:viewImg];
            

            [cell.contentView addSubview:viewImg];

            self.picImage = nil;
            
        } else {
            bgImage = [[UIImage imageNamed:@"GreenBubble2.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
            
            [cell.messageContentView setFrame:CGRectMake(320-size.width - padding, padding*2-13, size.width, size.height+5)];
            [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                                  cell.messageContentView.frame.origin.y - padding/2,
                                                  size.width + padding, size.height + padding)];
        }
    }
    
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    return cell;
}

- (IBAction)UesrClickedImg:(UITapGestureRecognizer*)sender {
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict  = [messages objectAtIndex:indexPath.row];
    CGFloat height;
    NSString *msg = [dict objectForKey:@"msg"];
//    NSString * msgType = [dict objectForKey:@"attachmentType"];
    
//    if ( msgType ) {
//        height = 100;
//    } else {
        CGSize textSize = {260.0 , 10000.0};
        CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
        
        size.height += padding*3;
        
        height = size.height < 75 ? 75 : size.height;
//    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)btnRecordClick{
    btnRec.enabled = YES;
    [self recStoped];
    //    UITextView * vt = [self.view
}

- (void) playAudio {
    NSError *error;
    if ( aiData ) {
        if ( !self.avPlayer ) {
            self.avPlayer = [[AVAudioPlayer alloc] initWithData:aiData error:&error];
        }
        [self.avPlayer prepareToPlay];
        self.avPlayer.delegate = self;
        [self.avPlayer play];
    }
}

- (void) showImage {
    NSError *error;
    if ( imgData ) {
        
    }
}


- (IBAction)toRecord:(id)sender {
    [(UIButton*)sender setEnabled:NO];
    [messageTextField resignFirstResponder];
    if ([self preRecord]) {
        recorder.meteringEnabled = YES;
        [recorder record];
        [_micView show];
        _sec = 0;
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
}

-(BOOL)preRecord{
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:/*kAudioFormatAppleIMA4*/kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:/*44110.0f*/22050.0f /*8000.0f*/] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    //4 采样位数  默认 16
    [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    //(document目录的路径)
//    NSString *destinationString = [[self documentsPath]
//                                   stringByAppendingPathComponent:[NSString stringWithFormat: @"_%d.%@", wavId+1000, @"wav"/*@"caf"*/]];
    NSLog(@"Using File called: %@",_destinationString);
    recordedTmpFile = [NSURL fileURLWithPath: _destinationString];
    NSError *error;
    if ( !recorder ) {
        recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
    }
    return [recorder prepareToRecord];
}

-(void)recStoped{
    //    [(UIButton*)self.view viewWithTag:TAG_INPUT_TEXT].userInteractionEnabled = YES;
    [_micView hide];
    [recorder stop];
    btnRec.enabled = YES;
    [btnRec setImage:[UIImage imageNamed:@"已录音按钮"] forState:UIControlStateNormal];
    [btnRec setImage:[UIImage imageNamed:@"已录音按钮按下"] forState:UIControlStateHighlighted];
    
    [levelTimer invalidate];
    levelTimer = nil;
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(5, 37, 310, 30);
//    btn.tag = 1000;
//    [btn setBackgroundImage:[UIImage imageNamed:@"录音内容底图"] forState:UIControlStateNormal];
//    float recLong = msec/100;
//    NSLog(@"msec:%f, msec/100:%.2f",msec,msec/2);
////    if (_iWantRawData.recordingUrl) {
////        [btn setTitle:@"点击播放" forState:UIControlStateNormal];
////    }else {
//        [btn setTitle:[NSString stringWithFormat:@"%.2f 秒",recLong] forState:UIControlStateNormal];
////    }
//    
//    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(2.0, -195.0, 0, 0)];
//    [btn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 addTarget:self action:@selector(btn2Act) forControlEvents:UIControlEventTouchUpInside];
//    [btn2 setFrame:CGRectMake(285, 5, 39/2, 39/2)];
//    [btn2 setBackgroundImage:[UIImage imageNamed:@"删除录音内容"] forState:UIControlStateNormal];
//    [btn addSubview:btn2];
//    
//    [_scrllView addSubview:btn];
//    
//    UITextView *textview =  (UITextView*)[self.view viewWithTag:TAG_TEXTVIEW_CONTEXT];
//    textview.frame=CGRectMake(2, 30+7+30, 312, 120-40);
    
    _sec = 0;
    msec = 0;
    //    }
    //录制完成把文件转成amr的再保存
    
    NSData* cafData=[NSData dataWithContentsOfFile:_destinationString];
    
    NSLog(@"audioRecorderDidFinishRecording cafData len :%d \n",[cafData length]);
    
//    NSData*amrData=EncodeWAVEToAMR(cafData,1,16);
//    [amrData writeToFile:_amrPath atomically:YES];
//    NSLog(@"amrData len :%d \n",[amrData length]);
    
}

- (void)levelTimerCallback:(NSTimer *)timer {
    msec++;
    int intMSec=(int)fmod(msec, 100);
    
    //    NSLog(@"---------:%f,-------%d",msec, fmod(msec, 1000));
    if ( fmod(msec, 100) == 0 ) {
        _sec++;
        if ( 60==_sec ) {
            [self recStoped];
        }
    }
    
    NSString *strSec;
    NSString *strMSec;
    if (_sec<10) {
        strSec=[NSString stringWithFormat:@"0%d",_sec];
    }else {
        strSec=[NSString stringWithFormat:@"%d",_sec];
    }
    if (intMSec<10) {
        strMSec=[NSString stringWithFormat:@"0%d",intMSec];
    }else {
        strMSec=[NSString stringWithFormat:@"%d",intMSec];
    }
    [_micView changeValue:strSec msec:strMSec];
}


- (void) uploadFile {

//    NSData * soundData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"push" ofType:@"wav"]];
    NSData * soundData = [NSData dataWithContentsOfFile:_destinationString];
    if ( soundData && [soundData length] > 4096) {
        NSLog(@"%d",soundData.length);
        NSString *sound=[soundData base64EncodedString];
        NSLog(@"%d",sound.length);
        //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/msg.amr"];
        //    NSError *error = nil;
        //    BOOL write = [sound writeToFile:path atomically:YES encoding: NSUTF8StringEncoding error:&error];
        //    if (write) {
        //        NSLog(@"yes");
        //    }else{
        //        NSLog(@"no %@",error.description);
        //    }
        //    NSLog(@"%@",sound);
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        // [body setStringValue:@"image"];
        
        NSXMLElement *attachment = [NSXMLElement elementWithName:@"attachment"];
        [attachment setStringValue:sound];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        
        //    NSXMLElement *attachmentType = [NSXMLElement elementWithName:@"attaType"];
        //    [attachmentType setStringValue:@"Audio"];
        //    [message addChild:attachmentType];
        [message addAttributeWithName:@"attaType" stringValue:@"audio"];
        
        [message addChild:body];
        [message addChild:attachment];
        [self.xmppStream sendElement:message];
    }
    
    if ( self.picImage ) {
        NSData * dataImg = UIImageJPEGRepresentation(self.picImage, 0.5);
        NSString * strImg = [dataImg base64EncodedString];
        NSLog(@"image length: %d",strImg.length);
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        // [body setStringValue:@"image"];
        
        NSXMLElement *attachment = [NSXMLElement elementWithName:@"attachment"];
        [attachment setStringValue:strImg];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        
        [message addAttributeWithName:@"attaType" stringValue:@"image"];
        
        [message addChild:body];
        [message addChild:attachment];
        [self.xmppStream sendElement:message];
        
    }

}


//获取document目录的路径
- (NSString*) documentsPath {
    NSString *_documentsPath;
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsPath = [searchPaths objectAtIndex: 0];
    return _documentsPath;
}

- (IBAction)takePhoto:(id)sender {
    UIActionSheet *menu = [[UIActionSheet alloc] init];
    menu.delegate=self;
    menu.title=@"请选择";
    [menu addButtonWithTitle:@"拍照"];
    [menu addButtonWithTitle:@"选取照片"];
    if (self.picImage) {
        [menu addButtonWithTitle:@"清除图片"];
    }
    [menu addButtonWithTitle:@"取消"];
    if (self.picImage) {
        menu.cancelButtonIndex=3;
    }else{
        menu.cancelButtonIndex=2;
    }
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

- (IBAction)recorder:(id)sender {
}

- (IBAction)sendButton:(id)sender {
    
    //本地输入框中的信息
    NSString *message = self.messageTextField.text;
    
    if (message.length > 0) {
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:chatWithUser];
        NSLog(@"chatWithUser=%@",chatWithUser);
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
         NSLog(@"USERID=%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]);
        //组合
        [mes addChild:body];
        
        //发送消息
        [[self xmppStream] sendElement:mes];
        
        self.messageTextField.text = @"";
        [self.messageTextField resignFirstResponder];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        [dictionary setObject:message forKey:@"msg"];
        [dictionary setObject:@"you" forKey:@"sender"];
        //加入发送时间
        [dictionary setObject:[Statics getCurrentTime] forKey:@"time"];

        [messages addObject:dictionary];
        
        //重新刷新tableView
        [self.tView reloadData];
        
    }
    
    [self uploadFile];
}

- (void) removeRecFile {
    NSError *error;
    if( YES != [[NSFileManager defaultManager] removeItemAtPath:_destinationString error:&error] )
        NSLog(@"Unable to delete file: %@", [error description]);
//    
//    NSString *amrPath = [[self documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat: @"_%d.%@", 1000, @"amr"]];
//    if ( YES != [[NSFileManager defaultManager] removeItemAtPath:amrPath error:&error] )
//        NSLog(@"Unable to delete file: %@", [error description]);
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    printf("User Pressed Button %d\n", buttonIndex);
    switch (buttonIndex) {
        case 0:
            [self snapImage];
            break;
        case 1:
            [self pickImage];
            break;
        case 2:
            if (self.picImage) {
                self.picImage = nil;
            }
            break;
        default:
            break;
    }
}

//拍照
- (void) snapImage
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"设备没有照相功能"
                                                      message:nil delegate:nil
                                            cancelButtonTitle:@"关闭"
                                            otherButtonTitles:nil, nil];
        [al show];
        
        return;
    }
    // Present the camera interface
    if ( !ipc ) {
        ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
    }

    [self presentModalViewController:ipc animated:YES];
}

//选择
- (void)pickImage
{
    // Present the camera interface
    if ( !ipc) {
        ipc = [[UIImagePickerController alloc] init];
    }
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentModalViewController:ipc animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Recover the snapped image
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // Save the image to the album
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, nil,nil,nil);
    }
    self.picImage = image;
    [picker dismissModalViewControllerAnimated:YES];
}

//#pragma mark - ASMediaFocusDelegate
//- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
//{
//    return ((UIImageView *)view).image;
//}
//
//- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
//{
//    return self.parentViewController.view.bounds;
//}
//
//- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
//{
//    return self.parentViewController;
//}

//- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaPathForView:(UIView *)view
//{
//    NSString *path;
//    NSString *name;
//    
//    // Here, images are accessed through their name "1f.jpg", "2f.jpg", …
//    name = [NSString stringWithFormat:@"%df", ([self.imageViews indexOfObject:view] + 1)];
//    path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
//    
//    return path;
//}

#pragma mark KKMessageDelegate
-(void)newMessageReceived:(NSDictionary *)messageCotent{
    [messages addObject:messageCotent];
    [self.tView reloadData];
}

- (IBAction)closeButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(KKAppDelegate *)appDelegate{
    
    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

@end
