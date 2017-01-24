//
//  UIColor+ChangeColor.m
//  HomeWork6
//
//  Created by Eugene Mekhedov on 24.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "UIColor+ChangeColor.h"

@implementation UIColor(ChangeColor)

+(UIColor*) randomColor{
    return [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.f];
}

@end
