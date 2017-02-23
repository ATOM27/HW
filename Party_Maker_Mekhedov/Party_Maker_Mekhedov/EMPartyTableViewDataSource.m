//
//  PartyTableViewDataSource.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/23/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyTableViewDataSource.h"
#import "EMPartyListCell.h"
#import "PMRParty+initWithManagedObject.h"

@implementation EMPartyTableViewDataSource

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PMRPartyManagedObject"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    return fetchRequest;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMPartyListCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[EMPartyListCell reuseIdentifier]];
    PMRPartyManagedObject *object = [self.frc objectAtIndexPath:indexPath];
    PMRParty* party = [[PMRParty alloc] initWithManagedObject:object];
    
    [cell configureWithImageID:party.logoID partyName:party.name partyDate:party.startDate];
    
    return cell;
}


@end
