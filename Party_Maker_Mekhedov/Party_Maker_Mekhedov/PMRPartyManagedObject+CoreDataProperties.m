//
//  PMRPartyManagedObject+CoreDataProperties.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 22.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "PMRPartyManagedObject+CoreDataProperties.h"

@implementation PMRPartyManagedObject (CoreDataProperties)

+ (NSFetchRequest<PMRPartyManagedObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PMRPartyManagedObject"];
}

@dynamic creationDate;
@dynamic creatorID;
@dynamic descriptionText;
@dynamic endDate;
@dynamic latitude;
@dynamic logoID;
@dynamic longtitude;
@dynamic modificationDate;
@dynamic name;
@dynamic partyID;
@dynamic startDate;

@end
