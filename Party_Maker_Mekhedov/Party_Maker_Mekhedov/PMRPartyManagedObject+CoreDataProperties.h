//
//  PMRPartyManagedObject+CoreDataProperties.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 22.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "PMRPartyManagedObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PMRPartyManagedObject (CoreDataProperties)

+ (NSFetchRequest<PMRPartyManagedObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *creationDate;
@property (nullable, nonatomic, copy) NSString *creatorID;
@property (nullable, nonatomic, copy) NSString *descriptionText;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *logoID;
@property (nullable, nonatomic, copy) NSString *longtitude;
@property (nullable, nonatomic, copy) NSDate *modificationDate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *partyID;
@property (nullable, nonatomic, copy) NSDate *startDate;

@end

NS_ASSUME_NONNULL_END
