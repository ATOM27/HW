//
//  NSArray+ArrayCategory.m
//  HomeWork2
//
//  Created by Eugene Mekhedov on 17.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "NSArray+ArrayCategory.h"

@implementation NSArray (ArrayCategory)

-(void) printAll{
    
    for (id object in self){
        NSLog(@"%@", object);
    }
}

@end
