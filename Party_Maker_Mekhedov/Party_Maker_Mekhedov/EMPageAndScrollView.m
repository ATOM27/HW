//
//  EMPageAndScrollView.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 27.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPageAndScrollView.h"
#import "UIView+CircleProperty.h"

@implementation EMPageAndScrollView

- (instancetype)initWithPageFrame:(CGRect)pageFrame
{
    self = [super init];
    if (self) {
        
        self.frame = pageFrame;
        self.backgroundColor = [UIColor colorWithRed:68.f/255.f green:73.f/255.f blue:83.f/255.f alpha:1.f];
        self.layer.cornerRadius = 5.f;
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        [self createImagesInScrollView:scrollView];
        
        scrollView.contentSize = CGSizeMake([self.arrayWithImageView count] * CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
        
        UIPageControl* pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                                     CGRectGetMaxY(self.bounds) - 25,
                                                                                     CGRectGetWidth(self.bounds),
                                                                                     25)];
        
        pageControl.numberOfPages = [self.arrayWithImageView count];
        //[pageControl addTarget:self action:@selector(actionPageChanged:) forControlEvents:UIControlEventTouchDown];
        self.scrollView = scrollView;
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        [self addSubview:scrollView];
    }
    return self;
}

-(void) createImagesInScrollView:(UIScrollView*) scrollView{
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No Alcohol-100.png"]];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Coconut Cocktail-100.png"]];
    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Christmas Tree-100.png"]];
    UIImageView* imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Champagne-100.png"]];
    UIImageView* imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Birthday Cake-100.png"]];
    UIImageView* imageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Beer-100.png"]];
    
    self.arrayWithImageView = @[imageView1, imageView2, imageView3, imageView4, imageView5, imageView6];
    
    int counter = 1;
    for (UIImageView* currentImageView in self.arrayWithImageView){
        
        currentImageView.transform = CGAffineTransformScale(imageView1.transform, 0.7, 0.7);
        currentImageView.center = CGPointMake(scrollView.center.x * counter, scrollView.center.y - 10);
        [scrollView addSubview:currentImageView];
        counter+=2;
    }

}

#pragma mark - Actions

//-(void) actionPageChanged:(UIPageControl*)sender{
//    
//    CGPoint contentOffset = CGPointMake(sender.currentPage * CGRectGetWidth(self.frame), 0);
//    [self.scrollView setContentOffset:contentOffset
//                             animated:YES];
//    [self.scrollView setContentOffset:contentOffset animated:YES];
//
//}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self showCircle];
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
    self.pageControl.currentPage = currentPage;
}

@end
