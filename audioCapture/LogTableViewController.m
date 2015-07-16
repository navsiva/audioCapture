//
//  LogTableViewController.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "LogTableViewController.h"
#import <Parse/Parse.h>
#import "AudioClip.h"

@interface LogTableViewController ()

@property NSMutableArray *objects;

@end

@implementation LogTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.audioSearch.bounds.size.height - 50;
    self.tableView.bounds = newBounds;
    
    [PFUser enableAutomaticUser];

    [[PFUser currentUser] saveInBackground];

    
    UILongPressGestureRecognizer *cellLongPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    cellLongPressed.minimumPressDuration = .5; //seconds
    cellLongPressed.delegate = self;
    [self.tableView addGestureRecognizer:cellLongPressed];
    
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        
        AudioClip *object = self.objects[indexPath.row];
        
        [object deleteInBackgroundWithBlock:^(BOOL succeded, NSError *error){
            
            
            
            [self.objects removeObject:object];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
            
            

            
        }];
        
        
        
        

    }

    

}


-(void)viewWillAppear:(BOOL)animated {
    

    
    //using view will appear so that the view is refreshed everytime and not just on initial app launch

    PFQuery *query = [[PFQuery alloc] initWithClassName:@"AudioClip"];
    
    
   [query whereKey:@"creator" equalTo:[PFInstallation currentInstallation]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        self.objects = [objects mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    
    AudioClip *object = self.objects[indexPath.row];
    
    cell.textLabel.text = [object.audioClipName description];
    
//    cell.textLabel.text = [object.createdAt description];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
