//
//  EMPartyViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 01.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMAddPartyViewController.h"
#import "UIView+CircleProperty.h"
#import "EMPartyCreatedViewController.h"
#import "PMRCoreDataManager+Party.h"
#import "UIViewController+Alert.h"
#import "EMHTTPManager.h"
#import <CoreLocation/CoreLocation.h>
#import "EMMapViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "PMRParty+initWithDictionary.h"
#import "ImagesManager.h"


@interface EMAddPartyViewController ()

@property (strong, nonatomic) IBOutlet UIButton *chooseDateButton;
@property (strong, nonatomic) IBOutlet UITextField *paratyNameTextField;
@property (strong, nonatomic) IBOutlet UISlider *startSlider;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UISlider *endSlider;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *chooseDateCircle;
@property (strong, nonatomic) IBOutlet UIView *partyNameCircle;
@property (strong, nonatomic) IBOutlet UIView *startCircle;
@property (strong, nonatomic) IBOutlet UIView *endCircle;
@property (strong, nonatomic) IBOutlet UIView *logoCircle;
@property (strong, nonatomic) IBOutlet UIView *descriptionCircle;
@property (strong, nonatomic) IBOutlet UIView *finalCircle;


@property (strong, nonatomic) UIDatePicker* datePicker;
@property (strong, nonatomic) UIToolbar* toolForDate;

@property (strong, nonatomic) UIToolbar* toolForTextView;

@property (strong, nonatomic) UIView* lastSelectedObject;

@property (strong, nonatomic) NSArray* arrayWithImageNames;

@property (strong, nonatomic) NSString* creatorID;

@property(assign, nonatomic) BOOL isKeyboardVisible;

@end

@implementation EMAddPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isKeyboardVisible = NO;
    self.creatorID = [[NSUserDefaults standardUserDefaults] objectForKey:@"creatorID"];
    
    self.longitude = @"";
    self.latitude = @"";
    
    self.chooseDateButton.circle = self.chooseDateCircle;
    self.paratyNameTextField.circle = self.partyNameCircle;
    self.startSlider.circle = self.startCircle;
    self.endSlider.circle = self.endCircle;
    self.scrollView.circle = self.logoCircle;
    self.textView.circle = self.descriptionCircle;
    self.locationButton.circle = self.finalCircle;

    if(self.currentParty){
        [self settingsForCurrentParty];
    }
    self.paratyNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your party name"
                                                                 attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                              }
                                  ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self createImagesInScrollView:self.scrollView];
    
    if(self.currentParty){
        self.pageControll.currentPage = self.currentParty.logoID.integerValue;
        CGPoint contentOffset = CGPointMake(self.pageControll.currentPage * CGRectGetWidth(self.scrollView.frame), 0);
        [self.scrollView setContentOffset:contentOffset
                                 animated:YES];
        [self.scrollView setContentOffset:contentOffset animated:YES];
        
        if(![self.currentParty.latitude isEqualToString:@""] && ![self.currentParty.longtitude isEqualToString:@""]){
            CLLocation* location = [[CLLocation alloc] initWithLatitude:[self.currentParty.latitude floatValue] longitude:[self.currentParty.longtitude floatValue]];
            
            CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
            [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                NSString* address = nil;
                
                if (error){
                    NSLog(@"%@", [error localizedDescription]);
                }else{
                    
                    if ([placemarks count] > 0){
                        
                        CLPlacemark* placeMark = [placemarks firstObject];
                        address = ABCreateStringWithAddressDictionary(placeMark.addressDictionary, NO);
                        if([address isEqualToString:@""]){
                            address = placeMark.name;
                        }
                    }
                    
                    [self.locationButton setTitle:address forState:UIControlStateNormal];
                    
                }
            }];
        }
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(void)settingsForCurrentParty{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    [self.chooseDateButton setTitle:[dateFormatter stringFromDate:self.currentParty.startDate] forState:UIControlStateNormal];
    self.paratyNameTextField.text = self.currentParty.name;
    [dateFormatter setDateFormat:@"HH:mm"];
    self.startLabel.text = [dateFormatter stringFromDate:self.currentParty.startDate];
    self.startSlider.value = [self valueForSliderWithDate:self.currentParty.startDate];
    self.endSlider.value = [self valueForSliderWithDate:self.currentParty.endDate];
    self.endLabel.text = [dateFormatter stringFromDate:self.currentParty.endDate];
    self.textView.text = self.currentParty.descriptionText;
}

-(NSInteger)valueForSliderWithDate:(NSDate*)date{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString* strDate = [dateFormatter stringFromDate:date];

    NSArray* arr = [strDate componentsSeparatedByString:@":"];
    return ([[arr firstObject] integerValue]*60 + [[arr lastObject] integerValue]);
}

-(NSDate*)getDateWithSliderValue:(NSInteger)value{
    NSString* dateStr = [self getStringForSliderValue:value];
    dateStr = [NSString stringWithFormat:@"%@ %@", self.chooseDateButton.titleLabel.text, dateStr];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [dateFormatter dateFromString:dateStr];
}

#pragma mark - Action choose date

- (IBAction)actionChooseDate:(UIButton *)sender {
    if(self.isKeyboardVisible == YES){
        self.isKeyboardVisible = NO;
        [self.view endEditing:YES];
    }
    [self showCircleInView:sender];
    
    UIDatePicker* datePicker = [[UIDatePicker alloc] init];
    if(self.datePicker){
        return;
    }
    self.datePicker = datePicker;
    datePicker.frame = CGRectMake(0,
                                  CGRectGetMaxY(self.view.frame),
                                  CGRectGetWidth(self.view.frame), CGRectGetHeight(datePicker.frame));
    
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:datePicker];
    
    UIToolbar* toolForDate = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(datePicker.frame), CGRectGetWidth(self.view.frame), 40)];
    self.toolForDate = toolForDate;
    
    toolForDate.barTintColor = [UIColor colorWithRed:68.f/255.f green:73.f/255.f blue:83.f/255.f alpha:1.f];
    toolForDate.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem* cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actionCloseChooseDate:)];
    
    UIBarButtonItem* flexSpaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem* doneBar = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionDoneChooseDate:)];
    
    [doneBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]
                                      } forState:UIControlStateNormal];
    
    toolForDate.items = @[cancelBar,flexSpaceBar, doneBar];
    [self.view addSubview:toolForDate];
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         datePicker.frame = CGRectMake(0,
                                                       CGRectGetMaxY(self.view.frame) - CGRectGetHeight(datePicker.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame),
                                                       CGRectGetWidth(self.view.frame), CGRectGetHeight(datePicker.frame));
                         
                         toolForDate.frame = CGRectMake(0, CGRectGetMinY(datePicker.frame) - 40, CGRectGetWidth(self.view.frame), 40);
                     }
                     completion:nil];
    
    

}

-(void)actionCloseChooseDate:(UIBarButtonItem*) sender{
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.datePicker.frame = CGRectMake(0,
                                                            CGRectGetMaxY(self.view.frame),
                                                            CGRectGetWidth(self.view.frame), CGRectGetHeight(self.datePicker.frame));
                         
                         self.toolForDate.frame = CGRectMake(0, CGRectGetMinY(self.datePicker.frame), CGRectGetWidth(self.view.frame), 40);
                     }
                     completion:^(BOOL finished) {
                         
                         [self.datePicker removeFromSuperview];
                         [self.toolForDate removeFromSuperview];
                         self.datePicker = nil;
                         self.toolForDate = nil;
                     }];
}

-(void)actionDoneChooseDate:(UIBarButtonItem*) sender{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    [self.chooseDateButton setTitle:[dateFormatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.datePicker.frame = CGRectMake(0,
                                                            CGRectGetMaxY(self.view.frame),
                                                            CGRectGetWidth(self.view.frame), CGRectGetHeight(self.datePicker.frame));
                         
                         self.toolForDate.frame = CGRectMake(0, CGRectGetMinY(self.datePicker.frame), CGRectGetWidth(self.view.frame), 40);
                     }
                     completion:^(BOOL finished) {
                         
                         [self.datePicker removeFromSuperview];
                         [self.toolForDate removeFromSuperview];
                         self.datePicker = nil;
                         self.toolForDate = nil;
                     }];
    
}

#pragma mark - UITextFieldDelegate for party name

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self showCircleInView:textField];
    return YES;
}

#pragma mark - Action slider

- (IBAction)actionChangeScrollValue:(UISlider *)sender {
    [self showCircleInView:sender];

    NSString* resultString = [self getStringForSliderValue:sender.value];
    
    if([sender isEqual:self.startSlider]){
        self.startLabel.text = resultString;
    }else if([sender isEqual:self.endSlider]){
        self.endLabel.text = resultString;
    }
    
    if([sender isEqual:self.startSlider]){
        NSInteger difference = self.endSlider.value - sender.value;
        if(difference < 30){
            if(difference < 0){
                difference *= -1;
            }
            self.endSlider.value +=difference + 30;
            self.endLabel.text = [self getStringForSliderValue:self.endSlider.value];
        }
    }else if([sender isEqual:self.endSlider]){
        NSInteger difference = sender.value - self.startSlider.value;
        if(difference < 30){
            if(difference < 0){
                difference *= -1;
            }
            self.startSlider.value -= difference + 30;
            self.startLabel.text = [self getStringForSliderValue:self.startSlider.value];
        }
        
    }
}

-(NSString*)getStringForSliderValue:(float)value{
    
    NSInteger hours = value/60.f;
    NSInteger minutse = value - hours*60;
    
    NSString* resultString = nil;
    
        resultString = [NSString stringWithFormat:@"%02ld:", (long)hours];
        resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%02ld", (long)minutse]];

    return resultString;
}

#pragma mark - EMPageAndScrollView

-(void) createImagesInScrollView:(UIScrollView*) scrollView{
    

    NSMutableArray* arrayWithImageView = [NSMutableArray new];
    
    for(NSString* imageName in [ImagesManager sharedManager].arrayWithImages){
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [arrayWithImageView addObject:imageView];
    }
    UIImageView* imageView1 = [arrayWithImageView firstObject];
    
    self.scrollView.contentMode = UIViewContentModeCenter;
    int counter = 1;
    for (UIImageView* currentImageView in arrayWithImageView){
        
        currentImageView.transform = CGAffineTransformScale(imageView1.transform, 0.7, 0.7);
        currentImageView.center = CGPointMake(scrollView.center.x * counter, scrollView.center.y - 10);
        [scrollView addSubview:currentImageView];
            counter+=2;
    }
    
    self.scrollView.contentSize = CGSizeMake([arrayWithImageView count] * CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
    
    self.pageControll.numberOfPages = [arrayWithImageView count];
}

- (IBAction)actionPageChanged:(UIPageControl *)sender {
    [self showCircleInView:self.scrollView];
    CGPoint contentOffset = CGPointMake(sender.currentPage * CGRectGetWidth(self.scrollView.frame), 0);
    [self.scrollView setContentOffset:contentOffset
                             animated:YES];
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self showCircleInView:scrollView];
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    self.pageControll.currentPage = currentPage;
}


#pragma mark - Notifications

-(void)keyboardWillShow:(NSNotification*)notification{
    self.isKeyboardVisible = YES;
    if(self.datePicker){
        [UIView animateWithDuration:0.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.datePicker.frame = CGRectMake(0,
                                                                CGRectGetMaxY(self.view.frame),
                                                                CGRectGetWidth(self.view.frame), CGRectGetHeight(self.datePicker.frame));
                             
                             self.toolForDate.frame = CGRectMake(0, CGRectGetMinY(self.datePicker.frame), CGRectGetWidth(self.view.frame), 40);
                         }
                         completion:^(BOOL finished) {
                             
                             [self.datePicker removeFromSuperview];
                             [self.toolForDate removeFromSuperview];
                             self.datePicker = nil;
                             self.toolForDate = nil;
                         }];
    }
    if([self.textView isFirstResponder]){
        CGRect keyboardRect =
        [[[notification userInfo]
          objectForKey:UIKeyboardFrameBeginUserInfoKey]
         CGRectValue];
        
        float duration =
        [[[notification userInfo]
          objectForKey:UIKeyboardAnimationDurationUserInfoKey]
         floatValue];
        
        
        [self createToolBarWithKeyboardRect:keyboardRect];
        
        [UIView animateWithDuration:duration animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y -= keyboardRect.size.height; //+ CGRectGetHeight(self.frame);
            self.view.frame = viewFrame;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification*)notification {
    self.isKeyboardVisible = NO;
    if([self.textView isFirstResponder]){
        
        float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = 0;
            self.view.frame = viewFrame;
        }];
    }
}

#pragma mark - UITextView

-(void)actionCloseTextView:(UIBarButtonItem*) sender{
    [self.toolForTextView removeFromSuperview];
    self.toolForTextView = nil;
    [self.textView resignFirstResponder];
}

-(void)actionDoneTextView:(UIBarButtonItem*) sender{
    [self.toolForTextView removeFromSuperview];
    self.toolForTextView = nil;
    [self.textView resignFirstResponder];
}

-(void) createToolBarWithKeyboardRect:(CGRect)keyboardRect{
    
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(keyboardRect) - 40, CGRectGetWidth(keyboardRect), 40)];
    toolBar.barTintColor = [UIColor colorWithRed:68.f/255.f green:73.f/255.f blue:83.f/255.f alpha:1.f];
    toolBar.tintColor = [UIColor whiteColor];
    self.toolForTextView = toolBar;
    UIBarButtonItem* cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actionCloseTextView:)];
    
    UIBarButtonItem* flexSpaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem* doneBar = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(actionDoneTextView:)];
    
    [doneBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]
                                      } forState:UIControlStateNormal];
    
    toolBar.items = @[cancelBar,flexSpaceBar, doneBar];
    [self.view addSubview:toolBar];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self showCircleInView:textView];
    return YES;
}

#pragma mark - Save bar button

- (IBAction)actionSaveParty:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (![self isDataPartyOK]){
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    if(self.currentParty){
        [self saveChangesToCurrentParty];
        return;
    }
    
    NSString* startTime = [NSString stringWithFormat:@"%f", [[self getDateWithSliderValue:self.startSlider.value] timeIntervalSince1970]];
    NSString* endTime = [NSString stringWithFormat:@"%f",  [[self getDateWithSliderValue:self.endSlider.value] timeIntervalSince1970]];
    
    [[EMHTTPManager sharedManager] addPartyWithName:self.paratyNameTextField.text
                                          startTime:startTime
                                            endTime:endTime
                                             logoID:[NSString stringWithFormat:@"%ld", (long)self.pageControll.currentPage]
                                            comment:self.textView.text
                                           latitude:self.latitude
                                          longitude:self.longitude
                                         completion:^(NSDictionary *response, NSError *error) {
                                             if(error){
                                                 NSLog(@"%@",[error localizedDescription]);
                                             }
                                             if(![response valueForKey:@"error"]){
                                                 PMRParty* party = [[PMRParty alloc] initWithDictionary:response];
                                                 [[PMRCoreDataManager sharedStore] addNewParty:party completion:^(BOOL success) {
                                                     if(success){
                                                         [self makeNotificationToPaty:party];
                                                         [self performSegueWithIdentifier:@"PartyCreatedIdentifier" sender:self];
                                                    }
                                                 }];
                                             }
                                             self.navigationItem.rightBarButtonItem.enabled = YES;
                                         }];
}

-(void)saveChangesToCurrentParty{
    
    NSString* latitude;
    NSString* longtitude;
    if(![self.latitude isEqualToString:@""] && ![self.longitude isEqualToString:@""]){
        latitude = self.latitude;
        longtitude = self.longitude;
    }else{
        latitude = self.currentParty.latitude;
        longtitude = self.currentParty.longtitude;
    }
    
    NSString* partyID = self.currentParty.partyID;
    
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];

        NSString* startTime = [NSString stringWithFormat:@"%f", [[self getDateWithSliderValue:self.startSlider.value] timeIntervalSince1970]];
        NSString* endTime = [NSString stringWithFormat:@"%f",  [[self getDateWithSliderValue:self.endSlider.value] timeIntervalSince1970]];

        
        [[EMHTTPManager sharedManager] editPartyWithID:partyID
                                                  name:self.paratyNameTextField.text
                                             startTime:startTime
                                               endTime:endTime
                                                logoID:[NSString stringWithFormat:@"%ld", (long)self.pageControll.currentPage]
                                               comment:self.textView.text
                                              latitude:latitude
                                             longitude:longtitude
                                            completion:^(NSDictionary *response, NSError *error) {
                                                if(error){
                                                    NSLog(@"%@",[error localizedDescription]);
                                                }
                                                if(![response valueForKey:@"error"]){
                                                    PMRParty* party = [[PMRParty alloc] initWithDictionary:response];
                                                    [[PMRCoreDataManager sharedStore] editPartyWithParty:party completion:^(BOOL success) {
                                                        if(success){
                                                            self.currentParty = party;// for partyCreatedController label text
                                                            [self performSegueWithIdentifier:@"PartyCreatedIdentifier" sender:self];
                                                        }

                                                    }];
                                                }
                                                self.navigationItem.rightBarButtonItem.enabled = YES;
                                            }];
 }


#pragma mark - Check data

-(BOOL)isDataPartyOK{
    BOOL result = YES;;
    if([self.chooseDateButton.titleLabel.text isEqualToString:@"CHOOSE DATE"]){
        result = NO;
        [self alertWithTitle:@"Error!" message:@"You shoud enter the date!"];
    }else if([self.paratyNameTextField.text isEqualToString:@""]){
        result = NO;
        [self alertWithTitle:@"Error!" message:@"You shoud enter the party name!"];
    }
    return result;
}

#pragma mark - Local notification

-(void) makeNotificationToPaty:(PMRParty*) party{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.alertBody = [NSString stringWithFormat:@"%@ is about to begin!", party.name];
    localNotification.fireDate = [party.startDate dateByAddingTimeInterval:-3600];
    localNotification.userInfo = @{ @"name" : party.name };
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.category = @"LocalNotificationDefaultCategory";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Choose location button

- (IBAction)actionChooseLocationButtonTouched:(UIButton *)sender {
    [self showCircleInView:sender];
    [self performSegueWithIdentifier:@"showMapIdentifier" sender:self];
}


#pragma mark - Show circle

-(void) showCircleInView:(UIView*) view{
    if(!self.lastSelectedObject){
        [view.circle.subviews lastObject].hidden = NO;
        self.lastSelectedObject = view;
    }else{
        if([self.lastSelectedObject isEqual:view]){
            return;
        }
        [view.circle.subviews lastObject].hidden = NO;
        [self.lastSelectedObject.circle.subviews lastObject].hidden = YES;
        self.lastSelectedObject = view;
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PartyCreatedIdentifier"]){
        EMPartyCreatedViewController* vc = segue.destinationViewController;
        vc.navCont = self.navigationController;
        if(self.currentParty){
            vc.partyStatus = [NSString stringWithFormat:@"\"%@\" has been updated!", self.currentParty.name];
        }else{
            vc.partyStatus = @"New Party has been created!";
        }
    }
    
    if ([segue.identifier isEqualToString:@"showMapIdentifier"]){
        EMMapViewController* vc = segue.destinationViewController;
        if((![self.currentParty.longtitude isEqualToString:@""] && ![self.currentParty.latitude isEqualToString:@""]) || ([self.currentParty isEqual:nil])){
            vc.existingLatitude = [self.currentParty.latitude floatValue];
            vc.existingLongitude = [self.currentParty.longtitude floatValue];
        }
        if(![self.latitude isEqualToString:@""]){
            vc.existingLatitude = [self.latitude floatValue];
            vc.existingLongitude = [self.longitude floatValue];
        }
 
    }
}

@end
