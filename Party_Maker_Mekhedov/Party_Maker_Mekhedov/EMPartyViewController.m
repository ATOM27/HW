//
//  EMPartyViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 25.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyViewController.h"
#import "EMChooseDateButton.h"
#import "EMPartyNameTextField.h"
#import "EMSlider.h"
#import "EMPageAndScrollView.h"
#import "EMTextView.h"
#import "EMButton.h"
#import "UIView+CircleProperty.h"

@interface EMPartyViewController ()

@property (strong, nonatomic) UIView* mapPointObjectsView;
@property (strong, nonatomic) UIView* objectsView;
@property (strong, nonatomic) EMSlider* startSlider;
@property (strong, nonatomic) EMSlider* endSlider;
@property (strong, nonatomic) NSDictionary* rightObjects;


@end

const NSString* kChooseDateButton = @"chooseDateButton";
const NSString* kPartyNameField = @"partyNameField";
const NSString* kStartSlider = @"startSlider";
const NSString* kEndSlider = @"endSlider";
const NSString* kPageAndScroolView = @"pageAndScroolView";
const NSString* kTextView = @"textView";
const NSString* kSaveButton = @"saveButton";
const NSString* kCloseButton = @"closeButton";

@implementation EMPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationBarSettings];
    [self createObjectsView];
    [self createMapPointView];
    
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

#pragma mark - Create views

-(void) createMapPointView{
    
    EMChooseDateButton* dateButton = [self.rightObjects objectForKey:kChooseDateButton];
    EMButton* cancelButton = [self.rightObjects objectForKey:kCloseButton];
    
    CGFloat heightLine = cancelButton.center.y - dateButton.center.y;
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(20,
                                                                dateButton.center.y,
                                                                2,
                                                                heightLine)];
    lineView.backgroundColor = [UIColor colorWithRed:230.f/255.f green:224.f/255.f blue:213.f/255.f alpha:1.f];
    
    for(NSString* key in self.rightObjects){
        
        if([key isEqualToString:kSaveButton]){
            continue;
        }
        UIView* obj = [self.rightObjects objectForKey:key];
        
        UIView* circle = [[UIView alloc] initWithFrame:CGRectMake(14,
                                                                  0,
                                                                  15,
                                                                  15)];
        
        circle.center = CGPointMake(circle.center.x, obj.center.y);
        circle.layer.cornerRadius = CGRectGetWidth(circle.frame)/2;
        circle.backgroundColor = [UIColor colorWithRed:230.f/255.f green:224.f/255.f blue:213.f/255.f alpha:1.f];
        
        
        UIView* circleBigger = [[UIView alloc] initWithFrame:CGRectMake(13,
                                                                        0,
                                                                        25,
                                                                        25)];
        circleBigger.center = CGPointMake(circle.center.x, obj.center.y);
        circleBigger.layer.cornerRadius = CGRectGetWidth(circleBigger.frame)/2;
        circleBigger.backgroundColor = [UIColor colorWithRed:230.f/255.f green:224.f/255.f blue:213.f/255.f alpha:0.5f];
        circleBigger.hidden = YES;
        obj.circle = circleBigger;
        
        UILabel* textLabel = [[UILabel alloc] init];
        textLabel.textColor = [UIColor colorWithRed:230.f/255.f green:224.f/255.f blue:213.f/255.f alpha:1.f];
        textLabel.text = [self choseTextForMapWithObjectKey:key];
        textLabel.frame = CGRectMake(35,
                                     obj.center.y - 10,
                                     100,
                                     20);
        textLabel.font = [UIFont systemFontOfSize:12];
        [self.mapPointObjectsView addSubview:textLabel];
        [self.mapPointObjectsView addSubview:circle];
        [self.mapPointObjectsView addSubview:circleBigger];

    }
    
    [self.mapPointObjectsView addSubview:lineView];
}

-(NSString*) choseTextForMapWithObjectKey:(NSString*)key{
    
    NSString* returnString = nil;
    
    if([key isEqualToString:kChooseDateButton])
            returnString = @"CHOOSE DATE";
            
    if([key isEqualToString:kPartyNameField])
            returnString = @"PARTY NAME";
    
    if([key isEqualToString:kStartSlider])
            returnString = @"START SLIDER";
    
    if([key isEqualToString:kEndSlider])
            returnString = @"END SLIDER";
    
    if([key isEqualToString:kPageAndScroolView])
            returnString = @"LOGO";
    
    if([key isEqualToString:kTextView])
            returnString = @"DESCRIPTION";
    
    if([key isEqualToString:kCloseButton])
            returnString = @"FINAL";

    return returnString;
}

-(void)createObjectsView{
    
    UIView* mapPointObjectsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                                                    CGRectGetWidth(self.view.frame)*37.5/100,
                                                                    CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    
    [self.view addSubview:mapPointObjectsView];
    self.mapPointObjectsView = mapPointObjectsView;
    
    UIView* objectsView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.mapPointObjectsView.frame) + 1.f,
                                                                   CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                                                   CGRectGetWidth(self.view.frame)*59.4/100,
                                                                   CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.objectsView = objectsView;
    
    UIButton* chooseDateButton = [[EMChooseDateButton alloc] initWithObjectView:self.objectsView mainView:self.view];
    [objectsView addSubview:chooseDateButton];
    
    UITextField* partyNameField = [[EMPartyNameTextField alloc] initWithFrame:CGRectMake(0,
                                                                                10 + CGRectGetHeight(chooseDateButton.frame) + CGRectGetHeight(self.view.frame)*1.9f/100,
                                                                                CGRectGetWidth(objectsView.frame),
                                                                                CGRectGetHeight(self.view.frame)*6.4f/100)];
    [objectsView addSubview:partyNameField];
    
    
    EMSlider* startSlider = [[EMSlider alloc] initWithFrame:CGRectMake(45,
                                                                       CGRectGetMaxY(partyNameField.frame) + 30,
                                                                       CGRectGetWidth(objectsView.frame) - 45,
                                                                       10.f)
                                                 inMainView:objectsView
                                             timeLabelFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(partyNameField.frame) + 15,
                                                                       40,
                                                                       30)];
    self.startSlider = startSlider;
    [objectsView addSubview:startSlider];
    
    EMSlider* endSlider = [[EMSlider alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(startSlider.frame) + 30,
                                                                     CGRectGetWidth(objectsView.frame) - 45,
                                                                     10.f)
                                               inMainView:objectsView
                                           timeLabelFrame:CGRectMake(CGRectGetWidth(objectsView.frame) - 45,
                                                                     CGRectGetMaxY(startSlider.frame) + 15,
                                                                     40,
                                                                     30)];
    self.endSlider = endSlider;
    
    [startSlider addTarget:self action:@selector(actionCheckForSliderRange:) forControlEvents:UIControlEventTouchUpInside];
    [endSlider addTarget:self action:@selector(actionCheckForSliderRange:) forControlEvents:UIControlEventTouchUpInside];
    [objectsView addSubview:endSlider];
    
    
    [self.view addSubview:objectsView];
    
    EMPageAndScrollView* pageAndScroolView = [[EMPageAndScrollView alloc] initWithPageFrame:CGRectMake(0,
                                                                                         CGRectGetMaxY(endSlider.frame) + 25,
                                                                                         CGRectGetWidth(objectsView.frame),
                                                                                         CGRectGetHeight(self.view.frame)*17.6f/100)];
    
    [objectsView addSubview:pageAndScroolView];
    
    EMTextView* textView = [[EMTextView alloc] initWithFrame:CGRectMake(0,
                                                                        (CGRectGetMaxY(pageAndScroolView.frame) + CGRectGetHeight(self.view.frame)*1.9f/100),
                                                                        CGRectGetWidth(objectsView.frame),
                                                                        CGRectGetHeight(self.view.frame)*17.5f/100)
                                               andMainView:self.view];
    [objectsView addSubview:textView];
   
    EMButton* saveButton = [[EMButton alloc] initWithFrame:CGRectMake(0,
                                                                     (CGRectGetMaxY(textView.frame) + CGRectGetHeight(self.view.frame)*1.9f/100),
                                                                     CGRectGetWidth(objectsView.frame),
                                                                     CGRectGetHeight(self.view.frame)*6.3f/100)
                                                     color:[UIColor colorWithRed:140.f/255.f green:186.f/255.f blue:29.f/255.f alpha:1.f]
                                                      text:@"SAVE"];
    [objectsView addSubview:saveButton];
    
    __weak EMButton* weakButton = saveButton;
    saveButton.action = ^{
        
        if([chooseDateButton.titleLabel.text isEqualToString:@"CHOOSE DATE"]){
            [weakButton alertWithTitle:@"Error!" message:@"You shoud enter the date!" andViewConctroller:self];
            
        }else if([partyNameField.text isEqualToString:@""]){
            [weakButton alertWithTitle:@"Error!" message:@"You shoud enter the party name!" andViewConctroller:self];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    EMButton* closeButton = [[EMButton alloc] initWithFrame:CGRectMake(0,
                                                                       (CGRectGetMaxY(saveButton.frame) + CGRectGetHeight(self.view.frame)*1.9f/100),
                                                                       CGRectGetWidth(objectsView.frame),
                                                                       CGRectGetHeight(self.view.frame)*6.3f/100)
                                                      color:[UIColor colorWithRed:236.f/255.f green:71.f/255.f blue:19.f/255.f alpha:1.f]
                                                       text:@"CANCEL"];
    
    closeButton.action = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [objectsView addSubview:closeButton];
    
    self.rightObjects = @{kChooseDateButton:chooseDateButton,
                          kPartyNameField: partyNameField,
                          kStartSlider: startSlider,
                          kEndSlider: endSlider,
                          kPageAndScroolView: pageAndScroolView,
                          kTextView: textView,
                          kSaveButton: saveButton,
                          kCloseButton: closeButton
                         };
    
    
    
}

#pragma mark - Actions

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
