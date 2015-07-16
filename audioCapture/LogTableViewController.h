//
//  LogTableViewController.h
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableViewController : UITableViewController<UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *audioSearch;

@end
