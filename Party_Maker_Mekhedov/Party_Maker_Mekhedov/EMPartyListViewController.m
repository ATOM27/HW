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

@interface EMPartyListViewController ()

@property(strong, nonatomic) NSArray* arrayWithParties;
@end

@implementation EMPartyListViewController
-(void)loadView{
    [super loadView];
    
    self.arrayWithParties = [[NSArray alloc] init];
    self.arrayWithParties = [[PMRCoreDataManager sharedStore] getParties];
    [[PMRCoreDataManager sharedStore] deleteAllPartiesWithIDcompletion:^(BOOL success) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self resetDefaults];
    [[EMHTTPManager sharedManager] partyWithCreatorID:self.creatorID
                                           completion:^(NSDictionary *response, NSError *error) {
                                               NSArray* parties = [response objectForKey:@"response"];
                                               
                                               if(parties){
                                                   for (NSDictionary* partyDict in parties){
                                                       PMRParty* party = [[PMRParty alloc] initWithDictionary:partyDict];
                                                       [[PMRCoreDataManager sharedStore] addNewParty:party completion:^(BOOL success) {
                                                           [self.tableView reloadData];
                                                       }];
                                                   }
                                               }
                                           }];
//    NSData* dataParties = [[NSUserDefaults standardUserDefaults] objectForKey:kParties];
//    if(dataParties){
//        self.arrayWithParties = [NSKeyedUnarchiver unarchiveObjectWithData:dataParties];
//    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //NSData* dataParties = [[NSUserDefaults standardUserDefaults] objectForKey:kParties];
    self.arrayWithParties = [[PMRCoreDataManager sharedStore] getParties];
//    if(dataParties){
//        self.arrayWithParties = [NSKeyedUnarchiver unarchiveObjectWithData:dataParties];
//    }
    
    return [self.arrayWithParties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMPartyListCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[EMPartyListCell reuseIdentifier]];
    //EMParty* party = [self.arrayWithParties objectAtIndex:indexPath.row];
    PMRParty* party = [self.arrayWithParties objectAtIndex:indexPath.row];
    [cell configureWithImageName:party.logoImageName partyName:party.name partyDate:party.startDate];
    //[cell configureWithImage:party.logoImage partyName:party.name partyDate:party.date partyStartTime:party.startParty];
    
    return cell;
}



- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

#pragma mark - Tab bar actions

- (IBAction)actionAddParty:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addPartyIdentifier" sender:self];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"partyInfoIdentifier"]){
        EMPartyInfoViewController* partyInfovc = segue.destinationViewController;
        partyInfovc.creatorID = self.creatorID;
        partyInfovc.currentParty = [self.arrayWithParties objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
    if([segue.identifier isEqualToString:@"addPartyIdentifier"]){
        EMAddPartyViewController* addPartyvc = segue.destinationViewController;
        addPartyvc.creatorID = self.creatorID;
    }
}
@end
