//
//  ANTelePhoneFriendViewController.m
//  XmppDemo
//
//  Created by paulus.an on 14-1-17.
//  Copyright (c) 2014年 Bestone. All rights reserved.
//

#import "ANTelePhoneFriendViewController.h"
#import <AddressBook/AddressBook.h>


@interface ANTelePhoneFriendViewController ()

@end

@implementation ANTelePhoneFriendViewController

@synthesize myFriend;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    friendAndTel = [NSMutableArray array];
    numBoth = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    personArray = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSString *firstName, *lastName, *fullName;
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            accessGranted = granted; }); }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        accessGranted = YES; }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
    personArray = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    //        if ([sender tag]==0) {
    NSLog(@"personArray first: %@",[personArray firstObject]);
    for (id person in personArray)
    {
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
        {
            NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSLog(@"===%@",phone);
//            NSString *temp = @"english, french, japanese, chinese";
//            NSString *jap = @"japanese";
//            NSRange foundObj=[temp rangeOfString:jap options:NSCaseInsensitiveSearch];
//            if(foundObj.length>0) {
//                NSLog(@"Yes ! Jap found");
//            } else {
//                NSLog(@"Oops ! no jap"); 
//            }
            if ( [self.myFriend containsObject:phone] ) {
                numBoth++;
            }
        }
//        ABMultiValueRef mails = (ABMultiValueRef) ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonEmailProperty);
//        for(int i = 0 ;i < ABMultiValueGetCount(mails); i++)
//        {
//            NSString *mail = (__bridge NSString *)ABMultiValueCopyValueAtIndex(mails, i);
//            NSLog(@"==%@",mail);
//        }
    }
    //        }else {
    //            //删除信息
    //            //返回所有联系人到一个数组中
    //            CFArrayRef personArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //            CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
    //            for (int i =0;i<personCount;i++){
    //                ABRecordRef ref = CFArrayGetValueAtIndex(personArray, i);
    //                CFStringRef firstName1 = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
    //                CFStringRef lastName1 = ABRecordCopyValue(ref, kABPersonLastNameProperty);
    //                NSString *contactFirstLast = [NSString stringWithFormat: @"%@%@", (NSString *)firstName1,(NSString *)lastName1];
    //                if ([contactFirstLast isEqualToString:@"徐梦"]) {
    //                    //删除联系人
    //                    ABAddressBookRemoveRecord(addressBook, ref, nil);
    //                }
    //            }
    //            //保存电话本
    //            ABAddressBookSave(addressBook, nil);
    //            //释放内存
    //            //CFRelease(personRef);
    //            //        CFRelease(addressbookRef);
    //        }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger numRow = 0;
    if ( 0 == section ) {
        numRow = numBoth;
    } else {
        numRow = [personArray count];
    }
     NSLog(@"----section %d numberOfRowsInSection: %d",section,numRow);
    return numRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    
    if ( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    NSString *firstName;
    NSString *lastName;
    NSString *fullName;
    
    
    ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue((__bridge ABRecordRef)([personArray objectAtIndex:indexPath.row]), kABPersonPhoneProperty);
    NSMutableString *phone = [[NSMutableString alloc] init];
    for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
    {
        phone = [NSMutableString stringWithFormat:@"%@  %@", phone, ABMultiValueCopyValueAtIndex(phones, i)];
        NSLog(@"===%@",phone);
        
        if ( [myFriend containsObject:phone] ) {
            
        }
        
        cell.detailTextLabel.text = phone;
    }
    
    
    firstName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([personArray objectAtIndex:indexPath.row]), kABPersonFirstNameProperty);
    firstName = [firstName stringByAppendingFormat:@" "];
    lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([personArray objectAtIndex:indexPath.row]), kABPersonLastNameProperty);
    fullName = [lastName stringByAppendingFormat:@"%@",firstName];
    NSLog(@"===%@",fullName);
    cell.textLabel.text = fullName;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
