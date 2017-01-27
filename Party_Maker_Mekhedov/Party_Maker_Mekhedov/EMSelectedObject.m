//
//  EMSelectedObject.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMSelectedObject.h"

@implementation EMSelectedObject

+(EMSelectedObject*) sharedManager{
    
    static EMSelectedObject* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EMSelectedObject alloc] init];
    });
    return manager;
}

@end
