//
//  LogTableViewController.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "LogTableViewController.h"
#import "CaptureViewController.h"
#import <Parse/Parse.h>
#import "AudioClip.h"

@interface LogTableViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) AVAudioPlayer *player;

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
    
    
    //Display results when searchbar is empty
    if (searchController.searchBar.text.length < 1){
        
        self.clips = source;
        
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.audioClipName contains[c] %@", searchController.searchBar.text];
        
        self.clips = [[source filteredArrayUsingPredicate:predicate] mutableCopy];
        
    }

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];

    [self scopeChanged:self.scopeBar];
    
    //Setting tableview background to black
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
    

    //Setting searchbar color and style
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:10], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil]
     forState:UIControlStateNormal];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    [self.searchController.searchBar sizeToFit];
    [self.searchController.searchBar setShowsCancelButton:NO animated:YES];

    
    self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchController.searchBar.barTintColor = [UIColor blackColor];
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    self.searchController.searchBar.placeholder = (@"Search audio clips");
    

    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchResultsUpdater = self;
    
    
    
    //Setup automatic Parse user id for device
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] saveInBackground];

    //Setup and assign LPGR
    
 
    
    
    UILongPressGestureRecognizer *cellLongPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    cellLongPressed.minimumPressDuration = .5;
    cellLongPressed.delegate = self;
    
    [self.tableView addGestureRecognizer:cellLongPressed];

    
    [self updateSearchResultsForSearchController:self.searchController];
    
    
    
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self scopeChanged:self.scopeBar];
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    
    //Perform this after the long press is complete
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    
    

    //Set indexPath for deletion from long press position, remove objects from Parse
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

- (void)didReceiveMemoryWarning {

        [super didReceiveMemoryWarning];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return self.clips.count;
}

- (IBAction)scopeChanged:(id)sender {
    
    [self updateSearchResultsForSearchController:self.searchController];
    
    
    if (self.scopeBar.selectedSegmentIndex == 1){
        

        
        //Query Parse to capture all results marked as Public when scope changes
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"AudioClip"];
        
        [query orderByDescending:@"createdAt"];
        
        [query whereKey:@"isPublic" equalTo:[NSNumber numberWithBool:YES]];
        
        
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        

            self.allClips = [objects mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateSearchResultsForSearchController:self.searchController];
            });
            
        }];
        
        
    } else {
    

        PFQuery *query = [[PFQuery alloc] initWithClassName:@"AudioClip"];
        
        [query orderByDescending:@"createdAt"];

        
        [query whereKey:@"creator" equalTo:[PFInstallation currentInstallation]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            
            self.allClips = [objects mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self updateSearchResultsForSearchController:self.searchController];
                
                
                
            });
            
        }];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    
        AudioClip *object = self.clips[indexPath.row];
        
        cell.textLabel.text = [object.audioClipName description];

    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [self performSegueWithIdentifier:@"pushSearchAudio" sender:self];
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"pushSearchAudio"]) {
 
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        AudioClip *object = self.clips[indexPath.row];

        [[segue destinationViewController]setAudioClip:object];
        
        
        
        
        
    }
    
}

@end
