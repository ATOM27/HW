//
//  EMPartyListViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyListViewController.h"
#import "EMPartyListCell.h"
#import "EMParty.h"
#import "PMRCoreDataManager+Party.h"
#import "PMRParty+initWithDictionary.h"
#import "PMRParty.h"
#import "EMHTTPManager.h"
#import "EMAddPartyViewController.h"
#import "EMPartyInfoViewController.h"
#import "EMPartyTableViewDataSource.h"
#import "PMRParty+initWithManagedObject.h"

@interface EMPartyListViewController ()

@property(strong, nonatomic) EMPartyTableViewDataSource* dataSource;

@end

@implementation EMPartyListViewController
-(void)loadView{
    [super loadView];
    
    [[PMRCoreDataManager sharedStore] deleteAllPartiesWithIDcompletion:^(BOOL success) {
        
    }];
    self.creatorID = [[NSUserDefaults standardUserDefaults] objectForKey:@"creatorID"];
    self.arrayWithParties = [[NSArray alloc] init];
    self.arrayWithParties = [[PMRCoreDataManager sharedStore] getParties];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[EMPartyTableViewDataSource alloc] initWithTableView:self.tableView
                                                                    context:[PMRCoreDataManager sharedStore].mainThreadContext
                                                            reuseIdentifier:[EMPartyListCell reuseIdentifier]
                                                     cellConfigurationBlock:^(UITableViewCell *cell, NSManagedObject *item) {
                                                         PMRParty* party = [[PMRParty alloc] initWithManagedObject:(PMRPartyManagedObject*)item];
                                                         EMPartyListCell* pCell = (EMPartyListCell*)cell;
                                                         [pCell configureWithImageID:party.logoID
                                                                           partyName:party.name
                                                                           partyDate:party.startDate];
                                                     }];
    
    [[EMHTTPManager sharedManager] getPartiesWithCompletion:^(NSDictionary *response, NSError *error) {
                                               NSArray* parties = [response objectForKey:@"response"];
                                               if(parties){
                                                   for (NSDictionary* partyDict in parties){
                                                       PMRParty* party = [[PMRParty alloc] initWithDictionary:partyDict];
                                                       if([party.creatorID isEqualToString:self.creatorID]){
                                                           [[PMRCoreDataManager sharedStore] addNewParty:party completion:^(BOOL success) {
                                                               //[self updateTableViewWithParties];
                                                           }];
                                                       }
                                                   }
                                               }
                                           }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.dataSource.paused = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"partyInfoIdentifier" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return [self.arrayWithParties count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    EMPartyListCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[EMPartyListCell reuseIdentifier]];
//    PMRParty* party = [self.arrayWithParties objectAtIndex:indexPath.row];
//    [cell configureWithImageID:party.logoID partyName:party.name partyDate:party.startDate];
//    
//    return cell;
//}

#pragma mark - Tab bar actions

- (IBAction)actionAddParty:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addPartyIdentifier" sender:self];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"partyInfoIdentifier"]){
        EMPartyInfoViewController* partyInfovc = segue.destinationViewController;
        PMRParty* party = [[PMRParty alloc] initWithManagedObject:(PMRPartyManagedObject*)[self.dataSource objectAtIndex:[self.tableView indexPathForSelectedRow]]];
        partyInfovc.currentParty = party;
    }
    if([segue.identifier isEqualToString:@"addPartyIdentifier"]){
        EMAddPartyViewController* addPartyvc = segue.destinationViewController;
    }
}

-(void)updateTableViewWithParties{
    self.arrayWithParties = [[PMRCoreDataManager sharedStore] getParties];
    [self.tableView reloadData];
}
@end
