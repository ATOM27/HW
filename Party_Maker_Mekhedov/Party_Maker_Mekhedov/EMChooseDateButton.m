//
//  EMChooseDateButton.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 26.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMChooseDateButton.h"
#import "UIView+CircleProperty.h"

@implementation EMChooseDateButton

- (instancetype)initWithObjectView:(UIView*)objectsView mainView:(UIView*)mainView
{
    self = [super init];
    if (self) {
        
        self.mainView = mainView;
        
        self.frame = CGRectMake(0, 10, CGRectGetWidth(objectsView.frame), CGRectGetHeight(mainView.frame)*6.4f/100);
        self.backgroundColor = [UIColor colorWithRed:239.f/255.f green:177.f/255.f blue:27.f/255.f alpha:1.f];
        [self setTitle:@"CHOOSE DATE" forState:UIControlStateNormal];
        
        self.layer.cornerRadius = 5.f;
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        
        [self addTarget:self action:@selector(actionChooseDate:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

#pragma mark - Actions


-(void)actionChooseDate:(UIButton*) sender{
    
    [self showCircle];
    UIView* circleSelect = [[UIView alloc] initWithFrame:CGRectMake(25,
                                                                    0,
                                                                    25,
                                                                    25)];
    circleSelect.layer.cornerRadius = CGRectGetWidth(circleSelect.frame)/2;
    circleSelect.backgroundColor = [UIColor colorWithRed:230.f/255.f green:224.f/255.f blue:213.f/255.f alpha:1.f];
    circleSelect.center = CGPointMake(circleSelect.center.x, self.center.y);
    
    [self.mainView addSubview:circleSelect];

    UIDatePicker* datePicker = [[UIDatePicker alloc] init];
    if(self.datePicker){
        return;
    }
    self.datePicker = datePicker;
    
    datePicker.frame = CGRectMake(0,
                                  CGRectGetMaxY(self.mainView.frame),
                                  CGRectGetWidth(self.mainView.frame), CGRectGetHeight(datePicker.frame));
    
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.mainView addSubview:datePicker];
    
    UIToolbar* toolForDate = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(datePicker.frame), CGRectGetWidth(self.mainView.frame), 40)];
    self.toolForDate = toolForDate;
    
    toolForDate.barTintColor = [UIColor colorWithRed:68.f/255.f green:73.f/255.f blue:83.f/255.f alpha:1.f];
    toolForDate.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem* cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actionClose:)];

    UIBarButtonItem* flexSpaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    

    UIBarButtonItem* doneBar = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionDone:)];
    
    [doneBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]
                                      } forState:UIControlStateNormal];
    
    toolForDate.items = @[cancelBar,flexSpaceBar, doneBar];
    [self.mainView addSubview:toolForDate];
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        datePicker.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.mainView.frame) - CGRectGetHeight(datePicker.frame),
                                      CGRectGetWidth(self.mainView.frame), CGRectGetHeight(datePicker.frame));
        
        toolForDate.frame = CGRectMake(0, CGRectGetMinY(datePicker.frame) - 40, CGRectGetWidth(self.mainView.frame), 40);
    }
                     completion:nil];
    
    
    
}

-(void)actionClose:(UIBarButtonItem*) sender{
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.datePicker.frame = CGRectMake(0,
                                                       CGRectGetMaxY(self.mainView.frame),
                                                       CGRectGetWidth(self.mainView.frame), CGRectGetHeight(self.datePicker.frame));
                         
                         self.toolForDate.frame = CGRectMake(0, CGRectGetMinY(self.datePicker.frame), CGRectGetWidth(self.mainView.frame), 40);
                     }
                     completion:^(BOOL finished) {
                             
                             [self.datePicker removeFromSuperview];
                             [self.toolForDate removeFromSuperview];
                             self.datePicker = nil;
                             self.toolForDate = nil;
                     }];
}

-(void)actionDone:(UIBarButtonItem*) sender{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitle:[dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.datePicker.frame = CGRectMake(0,
                                                            CGRectGetMaxY(self.mainView.frame),
                                                            CGRectGetWidth(self.mainView.frame), CGRectGetHeight(self.datePicker.frame));
                         
                         self.toolForDate.frame = CGRectMake(0, CGRectGetMinY(self.datePicker.frame), CGRectGetWidth(self.mainView.frame), 40);
                     }
                     completion:^(BOOL finished) {
                         
                         [self.datePicker removeFromSuperview];
                         [self.toolForDate removeFromSuperview];
                         self.datePicker = nil;
                         self.toolForDate = nil;
                     }];

}

@end
