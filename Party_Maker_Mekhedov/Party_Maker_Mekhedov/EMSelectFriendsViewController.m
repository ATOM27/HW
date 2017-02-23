//
//  EMSelectFriendsViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/20/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMSelectFriendsViewController.h"
#import "EMHTTPManager.h"
#import "EMMapWithFriendViewController.h"

@interface EMSelectFriendsViewController ()

@property(strong, nonatomic) NSArray* arrayWithFriends;

@end

@implementation EMSelectFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(!self.checkedFriends){
        self.checkedFriends = [[NSMutableArray alloc] init];
    }
    self.arrayWithFriends = [[NSArray alloc] init];
    
    [[EMHTTPManager sharedManager] getAllUsersWithCompletion:^(NSDictionary *response, NSError *error) {
        self.arrayWithFriends = [response objectForKey:@"response"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayWithFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    cell.accessoryType = UIAccessibilityTraitNone;
    
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    
    NSDictionary* currentFriend = [self.arrayWithFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentFriend objectForKey:@"name"];
    if([self.checkedFriends indexOfObject:currentFriend] != NSNotFound){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary* selectedFriend = [self.arrayWithFriends objectAtIndex:indexPath.row];

    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.checkedFriends removeObject:selectedFriend];
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.checkedFriends addObject:selectedFriend];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    EMMapWithFriendViewController* vc = [self.navigationController.viewControllers firstObject];
    vc.checkedFriends = self.checkedFriends;
    [vc makeAnnotations];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
