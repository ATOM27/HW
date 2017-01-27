//
//  EMSelectedObject.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
@interface EMSelectedObject : NSObject


@property (strong, nonatomic) UIView* lastObject;

+(EMSelectedObject*) sharedManager;

@end
