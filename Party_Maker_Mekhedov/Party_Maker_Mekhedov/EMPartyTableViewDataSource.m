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

@end
