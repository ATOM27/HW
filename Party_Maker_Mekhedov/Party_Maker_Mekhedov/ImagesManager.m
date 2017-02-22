//
//  imagesManager.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 22.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "ImagesManager.h"

@implementation ImagesManager

+ (ImagesManager *)sharedManager {
    static ImagesManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ImagesManager alloc] init];
        if (manager) {
            manager.arrayWithImages = @[@"No Alcohol-100.png", @"Coconut Cocktail-100.png", @"Christmas Tree-100.png", @"Champagne-100.png", @"Birthday Cake-100.png", @"Beer-100.png"];
        }
    });
        return manager;
}
                  
@end
