//
//  ANTelePhoneFriendViewController.m
//  XmppDemo
//
//  Created by paulus.an on 14-1-17.
//  Copyright (c) 2014年 Bestone. All rights reserved.
//

#import "ANTelePhoneFriendViewController.h"
#import <AddressBook/AddressBook.h>
#import "Statics.h"

#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"


@interface ANTelePhoneFriendViewController ()

@end

@implementation ANTelePhoneFriendViewController

@synthesize myFriend;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        friendAndTel = [[NSMutableArray alloc] init];
        allPhoneNumber = [[NSMutableArray alloc] init];
        personArray = [[NSMutableArray alloc] init];
        allNameArray = [[NSMutableArray alloc] init];
        friendNameArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    numBoth = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self searchFriend];
}

-(void) searchFriend {
    
    NSString *firstName;
    NSString *lastName;
    NSString *fullName;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
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
    NSLog(@"===%@",[self.myFriend description]);
    
    personArray = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (id person in personArray)
    {
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
        {
            NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *strUrl = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            strUrl = [strUrl stringByReplacingOccurrencesOfString:@"-" withString:@""];
            strUrl = [strUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ( nil == strUrl ) {
                strUrl = @"存TMD个空号码!";
            }
            
            firstName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty);
            firstName = [firstName stringByAppendingFormat:@" "];
            lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);
            fullName = [lastName stringByAppendingFormat:@"%@",firstName];
            if ( nil == fullName ) {
                fullName = @"TMD没写名,无名氏!";
            }
            if ( [self.myFriend containsObject:[NSString stringWithFormat:@"%@@%@",strUrl,SERVER_DOMAIN]] ) {
                
                [friendAndTel insertObject:strUrl atIndex:numBoth];
                [friendNameArray insertObject:fullName atIndex:numBoth];
                numBoth++;
                NSLog(@"my friend : %@, numBoth: %d",strUrl,numBoth);
         
            } else  {
                
                NSArray * arr = (__bridge NSArray *)(ABMultiValueCopyArrayOfAllValues(phones));
                [allPhoneNumber insertObject:arr atIndex:numOthers];
                [allNameArray insertObject:fullName atIndex:numOthers];
                numOthers++;
//                NSLog(@"arr-:%@, numOthers: %d",[arr description],numOthers);
            }
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
		for (int i = 0; i < 27; i++)
//			if ([[self.sectionArray objectAtIndex:i] count])
				[indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
		//[indices addObject:@"\ue057"]; // <-- using emoji
		return indices;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [ALPHA rangeOfString:title].location;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    tableView.restorationIdentifier = @"testTTT";
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 300, 20)];
    [lab setBackgroundColor:[UIColor clearColor]];
    if ( 0 == section ) {
        lab.text = @"通讯录好友：";
    } else if ( 1== section ) {
        lab.text = @"我的通讯录：";
    }
    
    return  lab;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableString * str = [[NSMutableString alloc] init];
    if ( 0 == section ) {
        str = (NSMutableString*)@"通讯录好友str:";
    } else if (1 == section) {
        str = (NSMutableString*)@"我的通讯录str:";
    }
    return str;
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
        NSLog(@"----section000 %d numberOfRowsInSection: %d",section,numRow);
    } else {
        numRow = [personArray count];
        NSLog(@"----section111 %d numberOfRowsInSection: %d",section,numRow);
    }
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
    
    NSMutableString * phoneNumbersStr = [[NSMutableString alloc] init];
    
    if ( 0 == indexPath.section ) {
        cell.detailTextLabel.text = [friendAndTel objectAtIndex:indexPath.row];
        cell.textLabel.text = [friendNameArray objectAtIndex:indexPath.row];
    } else if ( 1 == indexPath.section ) {
        for ( int i = 0; i<[[allPhoneNumber objectAtIndex:indexPath.row] count]; i++ ) {
            [phoneNumbersStr appendString:[[allPhoneNumber objectAtIndex:indexPath.row] objectAtIndex:i]];
            [phoneNumbersStr appendString:@"  "];
        }
        cell.detailTextLabel.text = phoneNumbersStr;
        cell.textLabel.text = [allNameArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
