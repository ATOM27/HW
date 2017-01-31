//
//  EMXibPartyViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 30.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMXibPartyViewController.h"
#import "EMChooseDateButton.h"
#import "EMPartyNameTextField.h"
#import "EMSlider.h"
#import "EMPageAndScrollView.h"
#import "EMTextView.h"
#import "EMButton.h"
#import "UIView+CircleProperty.h"

@interface EMXibPartyViewController ()

@property (strong, nonatomic) IBOutlet UIView *mapPointObjectsView;
@property (strong, nonatomic) IBOutlet UIView *objectsView;
@property (strong, nonatomic) IBOutlet EMChooseDateButton *chooseDateButton;
@property (strong, nonatomic) IBOutlet EMPartyNameTextField *partyNameTextField;
@property (strong, nonatomic) IBOutlet EMSlider *startSlider;
@property (strong, nonatomic) IBOutlet UILabel *timeStartLabel;
@property (strong, nonatomic) IBOutlet EMSlider *endSlider;
@property (strong, nonatomic) IBOutlet UILabel *timeEndLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet EMPageAndScrollView *pageAndScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;
@property (strong, nonatomic) IBOutlet UIView *blueStripText;
@property (strong, nonatomic) IBOutlet EMTextView *textView;
@property (strong, nonatomic) IBOutlet EMButton *saveButton;
@property (strong, nonatomic) IBOutlet EMButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIView *chooseDateCircle;
@property (strong, nonatomic) IBOutlet UIView *partyNameCircle;
@property (strong, nonatomic) IBOutlet UIView *startCicrle;
@property (strong, nonatomic) IBOutlet UIView *endCircle;
@property (strong, nonatomic) IBOutlet UIView *logoCircle;
@property (strong, nonatomic) IBOutlet UIView *descriptionCircle;
@property (strong, nonatomic) IBOutlet UIView *finalCircle;


@end

@implementation EMXibPartyViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self navigationBarSettings];
    
    self.chooseDateButton.mainView = self.view;
    [self.chooseDateButton addTarget:self.chooseDateButton action:@selector(actionChooseDate:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseDateButton.circle = self.chooseDateCircle;
    
    self.partyNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your party name"
                                                                 attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                              }
                                  ];
    self.partyNameTextField.circle = self.partyNameCircle;
    self.partyNameTextField.returnKeyType = UIReturnKeyDone;
    self.partyNameTextField.delegate = self.partyNameTextField;
    
    [self.startSlider addTarget:self.startSlider action:@selector(actionValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.startSlider.timeLabel = self.timeStartLabel;
    self.startSlider.circle = self.startCicrle;
    
    [self.endSlider addTarget:self.endSlider action:@selector(actionValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.endSlider.timeLabel = self.timeEndLabel;
    self.endSlider.circle = self.endCircle;
    
    [self.startSlider addTarget:self action:@selector(actionCheckForSliderRange:) forControlEvents:UIControlEventTouchUpInside];
    [self.endSlider addTarget:self action:@selector(actionCheckForSliderRange:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.pageAndScrollView.scrollView = self.scrollView;
    self.pageAndScrollView.pageControl = self.pageControll;
    self.scrollView.delegate = self.pageAndScrollView;
    self.scrollView.pagingEnabled = YES;
    self.pageAndScrollView.circle = self.logoCircle;
    [self.pageAndScrollView createImagesInScrollView:self.scrollView];

    self.textView.delegate = self.textView;
    self.textView.mainView = self.view;
    self.textView.circle = self.descriptionCircle;
    [self.textView makeNotifications];
    
    [self.saveButton addTarget:self.saveButton action:@selector(actionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    __weak EMButton* weakButton = self.saveButton;
    __weak EMChooseDateButton* weakDateButton = self.chooseDateButton;
    __weak EMXibPartyViewController* vc = self;
    self.saveButton.action = ^{
        if([weakDateButton.titleLabel.text isEqualToString:@"CHOOSE DATE"]){
            [weakButton alertWithTitle:@"Error!" message:@"You shoud enter the date!" andViewConctroller:vc];
            
        }else if([vc.partyNameTextField.text isEqualToString:@""]){
            [weakButton alertWithTitle:@"Error!" message:@"You shoud enter the party name!" andViewConctroller:vc];
        }else{
            [vc.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self.cancelButton addTarget:self.cancelButton action:@selector(actionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.action = ^{
        [vc.navigationController popViewControllerAnimated:YES];
    };
    self.cancelButton.circle = self.cancelButton;

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation settings

-(void)navigationBarSettings{
    
    self.view.backgroundColor = [UIColor colorWithRed:46.f/255.f green:49.f/255.f blue:56.f/255.f alpha:1.f];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:68.f/255.f green:73.f/255.f blue:83.f/255.f alpha:1.f];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]
                                                                      }];
    self.title = @"CREATE PARTY";
}

#pragma mark - Slider

-(void)actionCheckForSliderRange:(EMSlider*) sender{
    
    if([sender isEqual:self.startSlider]){
        
        NSInteger difference = self.endSlider.value - sender.value;
        if(difference < 30){
            if(difference < 0){
                difference *= -1;
            }
            self.endSlider.value +=difference + 30;
            self.endSlider.timeLabel.text = [self getStringForSliderValue:self.endSlider.value];
        }
    }else{
        NSInteger difference = sender.value - self.startSlider.value;
        if(difference < 30){
            if(difference < 0){
                difference *= -1;
            }
            self.startSlider.value -= difference + 30;
            self.startSlider.timeLabel.text = [self getStringForSliderValue:self.startSlider.value];
        }
        
    }
}

-(NSString*)getStringForSliderValue:(float)value{
    
    NSInteger hours = value/60.f;
    NSInteger minutse = value - hours*60;
    
    NSString* resultString = nil;
    
    if(hours >= 10){
        resultString = [NSString stringWithFormat:@"%ld:", (long)hours];
    }else{
        resultString = [NSString stringWithFormat:@"0%ld:", (long)hours];
    }
    
    if (minutse >= 10){
        resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)minutse]];
    }else{
        resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"0%ld", (long)minutse]];
    }
    
    return resultString;
}

@end
