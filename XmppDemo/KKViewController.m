//
//  KKViewController.m
//  XmppDemo
//
//  Created by paul on 12-7-12.
//  Copyright (c) 2012年 ANHJ&Paul. All rights reserved.
//

#import "KKViewController.h"
#import "KKAppDelegate.h"
#import "KKChatController.h"
#import "ANTelePhoneFriendViewController.h"

#import <AddressBookUI/AddressBookUI.h>
#import "Statics.h"

@interface KKViewController (){
    
    //在线用户
    NSMutableArray *onlineUsers;
    //所有用户
    NSMutableArray * allFriends;
    
    NSString *chatUserName;
    
}

@end

@implementation KKViewController
@synthesize tView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toShowMsgInCell:)
                                                 name:@"Have a msg"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeNaviBarItemWhenLogined)
                                                 name:@"Login Success"
                                               object:nil];
    
    onlineUsers = [NSMutableArray array];
    allFriends = [NSMutableArray array];
    
    //设定在线用户委托
    KKAppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
    if( [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 ) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

}

-(void) toShowMsgInCell:(NSNotification*)obj {
    NSLog(@"recieved");
    XMPPMessage * msg = obj.object;

    NSString *body = [[msg elementForName:@"body"] stringValue];
    NSLog(@"body==%@",body);
    NSString *xmppName = [msg fromStr];
    NSRange range = [xmppName rangeOfString:@"/"];//获取/的位置
    NSString *displayName = [xmppName substringToIndex:range.location];//开始截取
    NSInteger row = [onlineUsers indexOfObject:displayName];
    [tView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]].backgroundColor = [UIColor purpleColor];
}

-(void) changeNaviBarItemWhenLogined {
    self.loginAndLogout.title = [Statics isLogin] ? @"退出" : @"登陆";
    self.reginAndAddFriend.title = [Statics isLogin] ? @"加好友" : @"注册";
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSRange range = [userId rangeOfString:@"@"];//匹配得到的下标
    userId = [userId substringToIndex:range.location];//截取范围类的字符串
    self.title =[Statics isLogin] ? userId : @"未登陆";

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSRange range = [userId rangeOfString:@"@"];//匹配得到的下标
    userId = [userId substringToIndex:range.location];//截取范围类的字符串
    self.title =[Statics isLogin] ? userId : @"未登陆";

    self.loginAndLogout.title = [Statics isLogin] ? @"退出" : @"登陆";
    self.reginAndAddFriend.title = [Statics isLogin] ? @"加好友" : @"注册";
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   /* if ( 0 == buttonIndex &&  100 != alertView.tag) {
        [self Account:self];
//        [self toChat];
    } else  */
    if ( 0 == buttonIndex &&  100 == alertView.tag ) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ( [textField.text length] > 0 ) {
            NSString * userStr = [NSString stringWithFormat:@"%@@%@",textField.text,SERVER_DOMAIN];
            KKAppDelegate *del = [self appDelegate];
            [del XMPPAddFriendSubscribe:userStr];
        }
    } else if ( 101 == alertView.tag && 0 == buttonIndex ) {
        [[self appDelegate] disconnect];
        [Statics setLoginFlag:NO];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:USERID];
        [defaults removeObjectForKey:PASS];
        [defaults removeObjectForKey:SERVER];
        [defaults synchronize];
        
        [self changeNaviBarItemWhenLogined];
        
        [onlineUsers removeAllObjects];
        [self.tView reloadData];
    }
    
//    ABPeoplePickerNavigationController *picker =
//    [[ABPeoplePickerNavigationController alloc] init];
//    picker.peoplePickerDelegate = self;
//    [self presentModalViewController:picker animated:YES];
}

- (void)viewDidUnload
{
    [self setTView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)Account:(id)sender {
    if ( [Statics isLogin] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出吗？" message:@"" delegate:self
                                              cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 101;
        [alert show];
        
    } else {
        //跳转login页面
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (IBAction)telePhoneBook:(id)sender {
    
    ANTelePhoneFriendViewController * telePhoneView = [[ANTelePhoneFriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
    telePhoneView.myFriend = [[NSArray alloc] initWithArray:allFriends];
    [self.navigationController pushViewController:telePhoneView animated:YES];
    
}

- (IBAction)actResignAndAddFriend:(id)sender {
    
    if ( [Statics isLogin] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入好友手机号码" message:@"" delegate:self
                                              cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 100;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        
     } else {
        [self performSegueWithIdentifier:@"resign" sender:self];
    }
    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {              // Default is 1 if not implemented

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [onlineUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //文本
    cell.textLabel.text = [onlineUsers objectAtIndex:[indexPath row]];
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
}




#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //start a Chat
    chatUserName = (NSString *)[onlineUsers objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"chat" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"chat"]) {
        
        KKChatController *chatController = segue.destinationViewController;
        
        chatController.chatWithUser = chatUserName;
    }
}

//取得当前程序的委托
-(KKAppDelegate *)appDelegate{
    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    
    if ( ![allFriends containsObject:buddyName] ) {
        [allFriends addObject:buddyName];
        
    }
    
    if (![onlineUsers containsObject:buddyName]) {
        [onlineUsers addObject:buddyName];
        [self.tView reloadData];
    }
    
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
   
    if ( ![allFriends containsObject:buddyName] ) {
        [allFriends addObject:buddyName];
        
    }
    [onlineUsers removeObject:buddyName];
    [self.tView reloadData];
    

}


@end
