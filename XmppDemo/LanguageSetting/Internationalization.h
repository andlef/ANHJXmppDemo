//
//  Internationalization.h
//
//
//  Created by paulus.an on 12-3-31.
//  Copyright (c) 2012年 ANHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseController.h"

@class GetStringForLang;
@interface Internationalization : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView         *   myTableView;
    NSArray             *   languageArray;
    GetStringForLang    *   getString4Lang;
    int     langSelectedRow;
}

@end
