//
//  Internationalization.m
//  
//
//  Created by paulus.an on 12-3-31.
//  Copyright (c) 2012年 ANHJ. All rights reserved.
//

#import "Internationalization.h"
#import "GetStringForLang.h"

@interface Internationalization ()

@end

@implementation Internationalization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor colorWithRed:218.4075/255 green:209.5335/255 blue:202.9035/255 alpha:1]];
        getString4Lang = [[GetStringForLang alloc] init];
        languageArray = [[NSArray alloc] initWithObjects:@"简体中文", @"繁體中文", @"English", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];

	myTableView.backgroundColor = [UIColor colorWithRed:218.4075/255 green:209.5335/255 blue:202.9035/255 alpha:1];
	myTableView.separatorColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	[self.view addSubview:myTableView];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [languageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
    UITableViewCell * cell = nil;
    NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.textLabel.text = [languageArray objectAtIndex:row];
    if ( [[Language get_sLan] isEqualToString:@"zh-Hans"] && 0 == row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ( [[Language get_sLan] isEqualToString:@"zh-Hant"] && 1 == row ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ( [[Language get_sLan] isEqualToString:@"en"] && 2 == row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
	NSInteger row = [indexPath row];
    NSString * lang = @"en";
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];


       	switch (row) {
            case 0:
                lang = @"zh-Hans";
                break;
            case 1:
                lang = @"zh-Hant";
                break;
            case 2:
                lang = @"en";
            default:
                lang = @"en";
                break;
        }
        [Language setLanguage:lang];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LANG object:nil];
        //    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [myTableView reloadData]; 
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void) dealloc {
//    [myTableView release];
//    [languageArray release];
//    [getString4Lang release];
//    
//    [super dealloc];
//}

@end
