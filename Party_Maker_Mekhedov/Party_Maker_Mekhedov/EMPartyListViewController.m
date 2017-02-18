//
//  EMPartyListViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyListViewController.h"
#import "EMPartyViewController.h"
#import "EMPartyListCell.h"
#import "EMParty.h"
#import "PMRCoreDataManager+Party.h"
#import "PMRParty+initWithDictionary.h"
#import "PMRParty.h"
#import "EMHTTPManager.h"

@interface EMPartyListViewController ()

@property(strong, nonatomic) NSArray* arrayWithParties;
@property(strong, nonatomic) PMRParty* selectedParty;

@end

@implementation EMPartyListViewController
-(void)loadView{
    [super loadView];
    
    self.arrayWithParties = [[NSArray alloc] init];
    self.arrayWithParties = [[PMRCoreDataManager sharedStore] getParties];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self resetDefaults];
    [[EMHTTPManager sharedManager] partyWithCreatorID:self.creatorID//@"354"
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
    
    EMPartyViewController* vc = segue.destinationViewController;
    vc.creatorID = self.creatorID;
    
    if([segue.identifier isEqualToString:@"changePartyIdentifier"]){
        self.selectedParty = [self.arrayWithParties objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        vc.currentParty = self.selectedParty;
        vc.indexParty = [self.tableView indexPathForSelectedRow].row;
    }
}
@end
