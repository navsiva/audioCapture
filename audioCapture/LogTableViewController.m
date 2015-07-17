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

@interface LogTableViewController () <UISearchResultsUpdating>

@property NSMutableArray *clips;
@property NSMutableArray *allClips;
@property NSMutableArray *allPublicClips;



@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation LogTableViewController

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    
    NSMutableArray *source;
    
    if (searchController.searchBar.selectedScopeButtonIndex == 0){
        
        source = self.allClips;

    } else {
        
        source = self.allPublicClips;
    }
    
    
    
    
    //populate tableview with results even though no items have been currently searched
    
    if (searchController.searchBar.text.length < 1){
        
        self.clips = source;
        
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.audioClipName contains[c] %@", searchController.searchBar.text];

        
        self.clips = [[source filteredArrayUsingPredicate:predicate] mutableCopy];
        
    }
    
    
    
   // self.clips = [NSMutableArray arrayWithArray:[source filteredArrayUsingPredicate:predicate] mutableCopy];
    
    [self.tableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Custom styling of tableview
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
    

    //Custom styling of searchbar
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:10], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil]
     forState:UIControlStateNormal];
    

    
    
   
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    [self.searchController.searchBar sizeToFit];
    
    [self.searchController.searchBar setShowsCancelButton:NO animated:YES];

    
    self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.searchController.searchBar.barTintColor = [UIColor blackColor];
    
    self.searchController.searchBar.placeholder = (@"Search audio clips");
    
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
  

    
    self.searchController.searchResultsUpdater = self;
    
    
    
    //adjust audioSearch bar height to be hidden on load
//    CGRect newBounds = self.tableView.bounds;
//    newBounds.origin.y = newBounds.origin.y + self.audioSearch.bounds.size.height - 50;
//    self.tableView.bounds = newBounds;
    
    //create anonymous PFUser
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] saveInBackground];

    //setup and assign LPGR
    UILongPressGestureRecognizer *cellLongPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    cellLongPressed.minimumPressDuration = .5;
    cellLongPressed.delegate = self;
    [self.tableView addGestureRecognizer:cellLongPressed];
    
}



-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //Perform this after the long press is complete
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    //Set indexPath for deletion from long press position
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil){
    
    NSLog(@"couldn't find index path");
    
    } else {
        
        AudioClip *object = self.clips[indexPath.row];
        
        [object deleteInBackgroundWithBlock:^(BOOL succeded, NSError *error){
            
        [self.clips removeObject:object];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            });
        }];
    }
}


-(void)viewWillAppear:(BOOL)animated {

    //Refresh objects from Parse everytime view appears
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"AudioClip"];
    
    [query whereKey:@"creator" equalTo:[PFInstallation currentInstallation]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        self.allClips = [objects mutableCopy];
        
        
//        self.filteredObjects = [NSMutableArray arrayWithCapacity:[objects count]];
//        
//        NSLog(@"%@", self.filteredObjects);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateSearchResultsForSearchController:self.searchController];
        });
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return self.filteredObjects.count;
//    } else {
        return self.clips.count;
//    }

    
    
}
- (IBAction)scopeChanged:(id)sender {
    
    [self updateSearchResultsForSearchController:self.searchController];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    
    
//    if (self.tableView == self.searchDisplayController.searchBar) {
//        AudioClip *object = self.filteredObjects[indexPath.row];
//        
//        cell.textLabel.text = [object.audioClipName description];
//    } else {
        AudioClip *object = self.clips[indexPath.row];
        
        cell.textLabel.text = [object.audioClipName description];
//        
//    }
//
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

//- (void)searchBarSearchButtonClicked:(UISearchBar *)audioSearch {
//    
//    NSLog(@"Search clicked");
//}
//-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
//    // Update the filtered array based on the search text and scope.
//    // Remove all objects from the filtered search array
//    [self.filteredObjects removeAllObjects];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
//    self.clips = [NSMutableArray arrayWithArray:[self.allClips filteredArrayUsingPredicate:predicate]];
//}
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
//    // Tells the table data source to reload when text changes
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    // Tells the table data source to reload when scope bar selection changes
//    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}

@end
