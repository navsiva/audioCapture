//
//  LogTableViewController.h
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableViewController : UITableViewController<UIGestureRecognizerDelegate, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *scopeBar;

@end
