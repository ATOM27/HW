//
//  ViewController.m
//  HomeWork5
//
//  Created by Eugene Mekhedov on 23.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//@property (strong, nonatomic) NSMutableArray* arrayWithEqualizerView;
@property (strong, nonatomic) NSMutableArray* arrayWithEqualizerTopView;
@property (strong, nonatomic) NSMutableArray* arrayWithEqualizerBottomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // self.arrayWithEqualizerView = [[NSMutableArray alloc] init];
    self.arrayWithEqualizerTopView = [[NSMutableArray alloc] init];
    self.arrayWithEqualizerBottomView = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer* doubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerDoubleFingerTap:)];
    doubleFingerTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleFingerTap];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTap];
    
    self.view.backgroundColor = [UIColor colorWithRed:24.f/255.f green:54.f/255.f blue:66.f/255.f alpha:1.f];
    
    UIView* centerLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMidY(self.view.frame),
                                                                  CGRectGetWidth(self.view.frame),
                                                                  2.f)];
    centerLine.backgroundColor = [UIColor colorWithRed:84.f/255.f green:113.f/255.f blue:125.f/255.f alpha:1.f];
    [self.view addSubview:centerLine];
    
    [self createEqualizer];
}

-(void) createEqualizer{
    // top lines
    [self createEqualizerWithEqualizerViewY:0.f equalizerLineExtraY:0.f equalizerLineExtraHeight:4.f];
    
    //bottom lines
    [self createEqualizerWithEqualizerViewY:CGRectGetMidY(self.view.frame) equalizerLineExtraY:4.f equalizerLineExtraHeight:0.f];
    
}

-(void) createEqualizerWithEqualizerViewY:(CGFloat)equalizerViewY equalizerLineExtraY:(CGFloat)equalizerLineExtraY equalizerLineExtraHeight:(CGFloat)equalizerLineExtraHeight {
    
    for (int i = 0; i < 39; i++){
        
        UIView* equalizerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/39.f * i ,
                                                                         equalizerViewY,
                                                                         CGRectGetWidth(self.view.frame)/39.f,
                                                                         CGRectGetHeight(self.view.frame)/2.f + 1.f)];
        
        // [self.arrayWithEqualizerView addObject:equalizerView];
        
        //equalizerView.layer.borderColor = [UIColor blueColor].CGColor;
        //equalizerView.layer.borderWidth = 1.f;
        
        [self.view addSubview:equalizerView];
        
        CGFloat equalizerLineY = 0;
        
        if(equalizerViewY == 0){
            equalizerLineY = CGRectGetMidY(equalizerView.bounds);
            [self.arrayWithEqualizerTopView addObject:equalizerView];
            
        }else{
            equalizerLineY = CGRectGetMinY(equalizerView.bounds);
            [self.arrayWithEqualizerBottomView addObject:equalizerView];
        }
        
        UIView* equalizerLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(equalizerView.bounds) + 2.f,
                                                                         equalizerLineY + equalizerLineExtraY,
                                                                         CGRectGetWidth(equalizerView.bounds) - 4.f,
                                                                         CGRectGetHeight(equalizerView.bounds)/2.f - equalizerLineExtraHeight)];
        
        equalizerLine.layer.cornerRadius = 5.f;
        equalizerLine.backgroundColor = [self getColorForEqualizerLineWithIndex:i];
        
        [equalizerView addSubview:equalizerLine];
        
    }
    
}

-(UIColor*) getColorForEqualizerLineWithIndex:(int)i{
    
    UIColor* returnColor = nil;
    
    
    if(i < 2 || i >= 37){
        returnColor = [UIColor colorWithRed:32.f/255.f green:87.f/255.f blue:110.f/255.f alpha:1.f];
    }
    
    else if(i < 6 || (i >= 33 && i <= 36)){
        returnColor = [UIColor colorWithRed:70.f/255.f green:154.f/255.f blue:184.f/255.f alpha:1.f];
    }
    
    else if(i < 10 || (i >= 29 && i <= 32)){
        returnColor = [UIColor colorWithRed:109.f/255.f green:179.f/255.f blue:191.f/255.f alpha:1.f];
    }
    
    else if(i < 14 || (i >= 25 && i <= 28)){
        returnColor = [UIColor colorWithRed:149.f/255.f green:207.f/255.f blue:202.f/255.f alpha:1.f];
    }
    
    else if(i < 18 || (i >= 21 && i <= 24)){
        returnColor = [UIColor colorWithRed:207.f/255.f green:233.f/255.f blue:244.f/255.f alpha:1.f];
    }
    
    else if(i < 21){
        returnColor = [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:1.f];
    }
    
    return returnColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touches

-(void) moveWithTouch:(NSSet<UITouch *> *) touches withEvent:(UIEvent*)event{
    
    UITouch* touch = [touches anyObject];
    CGPoint pointInMainView = [touch locationInView:self.view];
    UIView* touchedView = [self.view hitTest:pointInMainView withEvent:event];
    
    if ([self.arrayWithEqualizerTopView containsObject:touchedView]){
        UIView* v = [touchedView.subviews lastObject];
        CGPoint position = [touch locationInView:touchedView];
        
        CGRect frame = v.frame;
        frame.origin.y = (position.y);
        frame.size.height = CGRectGetHeight(touchedView.frame) - (position.y + 4.f);
        //        [UIView animateWithDuration:0.1f
        //                              delay:0.f
        //                            options:UIViewAnimationOptionCurveEaseInOut
        //                         animations:^{
        v.frame = frame;
        // } completion:nil];
        
    }else if([self.arrayWithEqualizerTopView containsObject:[touchedView superview]]){
        CGPoint position = [touch locationInView:[touchedView superview]];
        
        CGRect frame = touchedView.frame;
        frame.origin.y = (position.y);
        frame.size.height = CGRectGetHeight([touchedView superview].frame) - (position.y + 4.f);
        
        //        [UIView animateWithDuration:0.1f
        //                              delay:0.f
        //                            options:UIViewAnimationOptionCurveEaseInOut
        //                         animations:^{
        touchedView.frame = frame;
        //    } completion:nil];
    }
    
    if ([self.arrayWithEqualizerBottomView containsObject:touchedView]){
        UIView* v = [touchedView.subviews lastObject];
        CGPoint position = [touch locationInView:touchedView];
        
        CGRect frame = v.frame;
        
        frame.size.height = CGRectGetHeight(touchedView.frame) - (CGRectGetHeight(touchedView.frame) - (position.y));
        //        [UIView animateWithDuration:0.1f
        //                              delay:0.f
        //                            options:UIViewAnimationOptionCurveEaseInOut
        //                         animations:^{
        v.frame = frame;
        // } completion:nil];
        
    }else if ([self.arrayWithEqualizerBottomView containsObject:[touchedView superview]]){
        CGPoint position = [touch locationInView:[touchedView superview]];
        
        CGRect frame = touchedView.frame;
        
        frame.size.height = CGRectGetHeight([touchedView superview].frame) - (CGRectGetHeight([touchedView superview].frame) - (position.y));
        //        [UIView animateWithDuration:0.1f
        //                              delay:0.f
        //                            options:UIViewAnimationOptionCurveEaseInOut
        //                         animations:^{
        touchedView.frame = frame;
        // } completion:nil];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveWithTouch:touches withEvent:event];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveWithTouch:touches withEvent:event];
}

#pragma mark - Gestures

-(void) handlerDoubleFingerTap:(UITapGestureRecognizer*) tapGesture{
    
    self.view.backgroundColor = [UIColor colorWithRed:24.f/255.f green:54.f/255.f blue:66.f/255.f alpha:1.f];
    
    for (UIView* v in self.arrayWithEqualizerTopView){
        [[[v.subviews lastObject] layer] removeAllAnimations];
    }
    
    for (UIView* v in self.arrayWithEqualizerBottomView){
        [[[v.subviews lastObject] layer] removeAllAnimations];
    }
    
}

-(void) handleDoubleTap:(UITapGestureRecognizer*) tapGesture{
    
    self.view.backgroundColor = [UIColor colorWithRed:32.f/255.f green:87.f/255.f blue:110.f/255.f alpha:1.f];
    int counter = 0;
    for (UIView* equalizerView in self.arrayWithEqualizerTopView){
        
        UIView* v = [equalizerView.subviews lastObject];
        
        [UIView animateWithDuration:2.f
                              delay:0.f options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             v.frame = CGRectMake(CGRectGetMinX(equalizerView.bounds) + 2.f,
                                                  CGRectGetMidY(equalizerView.bounds),
                                                  CGRectGetWidth(equalizerView.bounds) - 4.f,
                                                  CGRectGetHeight(equalizerView.bounds)/2.f - 4.f);
                         } completion:nil];
        
        [UIView animateWithDuration:0.5f
                              delay:counter*0.05f
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             v.frame = CGRectMake(CGRectGetMinX(equalizerView.bounds) + 2.f,
                                                  CGRectGetMaxY(equalizerView.bounds) - 8.f,
                                                  CGRectGetWidth(equalizerView.bounds) - 4.f,
                                                  9.f - 4.f);
                         }
                         completion:nil];
        
        counter++;
    }
    
    counter = 0;
    for (UIView* equalizerView in self.arrayWithEqualizerBottomView){
        
        UIView* v = [equalizerView.subviews lastObject];
        
        [UIView animateWithDuration:2.f
                              delay:0.f options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             v.frame = CGRectMake(CGRectGetMinX(equalizerView.bounds) + 2.f,
                                                  CGRectGetMinY(equalizerView.bounds) + 4.f,
                                                  CGRectGetWidth(equalizerView.bounds) - 4.f,
                                                  9.f - 4.f);
                             
                         } completion:nil];
        [UIView animateWithDuration:0.5f
                              delay:counter*0.05f
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             v.frame = CGRectMake(CGRectGetMinX(equalizerView.bounds) + 2.f,
                                                  CGRectGetMinY(equalizerView.bounds) + 4.f,
                                                  CGRectGetWidth(equalizerView.bounds) - 4.f,
                                                  CGRectGetHeight(equalizerView.bounds)/2.f - 4.f);
                         }
                         completion:nil];
        counter++;
    }
    
    
}

@end
