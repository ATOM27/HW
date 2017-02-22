//
//  imagesManager.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 22.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagesManager : NSObject

@property(strong, nonatomic) NSArray* arrayWithImages;

+ (ImagesManager *)sharedManager;

@end
