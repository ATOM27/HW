//
//  EMPageAndScrollView.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPageAndScrollView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray* arrayWithImageView;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIPageControl* pageControl;

- (instancetype)initWithPageFrame:(CGRect)pageFrame;

@end
