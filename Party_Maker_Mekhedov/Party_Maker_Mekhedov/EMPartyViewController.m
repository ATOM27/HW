//
//  EMPartyViewController.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 01.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyViewController.h"
#import "UIView+CircleProperty.h"
#import "EMPartyCreatedViewController.h"
#import "PMRCoreDataManager+Party.h"

@interface EMPartyViewController ()

@property (strong, nonatomic) IBOutlet UIButton *chooseDateButton;
@property (strong, nonatomic) IBOutlet UITextField *paratyNameTextField;
@property (strong, nonatomic) IBOutlet UISlider *startSlider;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UISlider *endSlider;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;
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
@end

NS_ENUM(NSInteger, EMSliderType){
    EMSliderTypeStart,
    EMSliderTypeEnd
};

@implementation EMPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chooseDateButton.circle = self.chooseDateCircle;
    self.paratyNameTextField.circle = self.partyNameCircle;
    self.startSlider.circle = self.startCircle;
    self.endSlider.circle = self.endCircle;
    self.scrollView.circle = self.logoCircle;
    self.textView.circle = self.descriptionCircle;
    self.locationButton.circle = self.finalCircle;

    if(self.currentParty){
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        [self.chooseDateButton setTitle:[dateFormatter stringFromDate:self.currentParty.creationDate] forState:UIControlStateNormal];
        self.paratyNameTextField.text = self.currentParty.name;
        [dateFormatter setDateFormat:@"HH:mm"];
        self.startLabel.text = [dateFormatter stringFromDate:self.currentParty.startDate];
        self.startSlider.value = [self valueForSliderWithDate:self.currentParty.startDate];
        self.endSlider.value = [self valueForSliderWithDate:self.currentParty.endDate];
        self.endLabel.text = [dateFormatter stringFromDate:self.currentParty.endDate];
        //self.pageControll.currentPage = self.currentParty.logoPage;
        self.textView.text = self.currentParty.descriptionText;
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
        self.pageControll.currentPage = [self.arrayWithImageNames indexOfObject:self.currentParty.logoImageName];
        CGPoint contentOffset = CGPointMake(self.pageControll.currentPage * CGRectGetWidth(self.scrollView.frame), 0);
        [self.scrollView setContentOffset:contentOffset
                                 animated:YES];
        [self.scrollView setContentOffset:contentOffset animated:YES];
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
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [dateFormatter dateFromString:dateStr];
}

#pragma mark - Action choose date

- (IBAction)actionChooseDate:(UIButton *)sender {
    [self showCircleInView:sender];
    //[sender showCircle];
//    UIView* circleSelect = [[UIView alloc] initWithFrame:CGRectMake(25,
//                                                                    0,
//                                                                    25,
//                                                                    25)];
//    circleSelect.layer.cornerRadius = CGRectGetWidth(circleSelect.frame)/2;
//    circleSelect.backgroundColor = [UIColor colorWithRed:230.f/255.f green:224.f/255.f blue:213.f/255.f alpha:1.f];
//    circleSelect.center = CGPointMake(circleSelect.center.x, sender.center.y);
//    
//    [self.view addSubview:circleSelect];
    
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
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    //[textField showCircle];
    [self showCircleInView:textField];
    return YES;
}

#pragma mark - Action slider

- (IBAction)actionChangeScrollValue:(UISlider *)sender {
    //[sender showCircle];
    [self showCircleInView:sender];

    NSString* resultString = [self getStringForSliderValue:sender.value];
    
    if(sender.tag == EMSliderTypeStart){
        self.startLabel.text = resultString;
    }else if(sender.tag == EMSliderTypeEnd){
        self.endLabel.text = resultString;
    }
    
    if(sender.tag == EMSliderTypeStart){
        
        NSInteger difference = self.endSlider.value - sender.value;
        if(difference < 30){
            if(difference < 0){
                difference *= -1;
            }
            self.endSlider.value +=difference + 30;
            self.endLabel.text = [self getStringForSliderValue:self.endSlider.value];
        }
    }else if(sender.tag == EMSliderTypeEnd){
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

#pragma mark - EMPageAndScrollView

-(void) createImagesInScrollView:(UIScrollView*) scrollView{
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No Alcohol-100.png"]];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Coconut Cocktail-100.png"]];
    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Christmas Tree-100.png"]];
    UIImageView* imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Champagne-100.png"]];
    UIImageView* imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Birthday Cake-100.png"]];
    UIImageView* imageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Beer-100.png"]];
    
    NSArray* arrayWithImageView = @[imageView1, imageView2, imageView3, imageView4, imageView5, imageView6];
    self.arrayWithImageNames = @[@"No Alcohol-100.png", @"Coconut Cocktail-100.png", @"Christmas Tree-100.png", @"Champagne-100.png", @"Birthday Cake-100.png", @"Beer-100.png"];
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
    CGPoint contentOffset = CGPointMake(sender.currentPage * CGRectGetWidth(self.scrollView.frame), 0);
    [self.scrollView setContentOffset:contentOffset
                             animated:YES];
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   // [scrollView showCircle];
    [self showCircleInView:scrollView];
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    self.pageControll.currentPage = currentPage;
}


#pragma mark - Notifications

-(void)keyboardWillShow:(NSNotification*)notification{
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
    if([self.textView isFirstResponder]){
        
        float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        //__block __weak UIView *mainView = self.mainView;
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
   // [self.textView showCircle];
    [self showCircleInView:textView];
    return YES;
}

#pragma mark - Alert controller

-(void) alertWithTitle:(NSString*) title message:(NSString*)message andViewConctroller:(UIViewController*) vc{
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [vc presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Save button

//- (IBAction)actionSaveButtonTouched:(UIButton *)sender {
//    //[sender showCircle];
//    [self showCircleInView:sender];
//    if([self isDataPartyOK]){
//            [self performSegueWithIdentifier:@"PartyCreatedIdentifier" sender:self];
//            [self.navigationController popViewControllerAnimated:YES];
//    }
//}

#pragma mark - Check data

-(BOOL)isDataPartyOK{
    BOOL result = YES;;
    if([self.chooseDateButton.titleLabel.text isEqualToString:@"CHOOSE DATE"]){
        result = NO;
        [self alertWithTitle:@"Error!" message:@"You shoud enter the date!" andViewConctroller:self];
    }else if([self.paratyNameTextField.text isEqualToString:@""]){
        result = NO;
        [self alertWithTitle:@"Error!" message:@"You shoud enter the party name!" andViewConctroller:self];
    }
    return result;
}

-(void)saveParty{
    if(self.currentParty){
        [self saveChangesToCurrentParty];
        return;
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSDate* date = [dateFormatter dateFromString:self.chooseDateButton.titleLabel.text];
    
    
    //UIImageView* imageView = [self.scrollView.subviews objectAtIndex:self.pageControll.currentPage];
    PMRParty* party = [[PMRParty alloc] initWithPartyID:@""
                                                   name:self.paratyNameTextField.text
                                              startDate:[self getDateWithSliderValue:self.startSlider.value]
                                                endDate:[self getDateWithSliderValue:self.endSlider.value]
                                          logoImageName:[self.arrayWithImageNames objectAtIndex:self.pageControll.currentPage]
                                        descriptionText:self.textView.text
                                           creationDate:date
                                       modificationDate:nil
                                              creatorID:nil
                                               latitude:nil
                                             longtitude:nil];
    
    [[PMRCoreDataManager sharedStore] addNewParty:party completion:^(BOOL success) {
        if(success){
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            
            localNotification.alertBody = [NSString stringWithFormat:@"%@ is about to begin!", party.name];
            localNotification.fireDate = [party.startDate dateByAddingTimeInterval:-3600];
            localNotification.userInfo = @{ @"name" : party.name };
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.category = @"LocalNotificationDefaultCategory";

            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }];
//    [[EMParty alloc] initWithDate:date
//                                              name:self.paratyNameTextField.text
//                                    startPartyTime:self.startSlider.value
//                                      endPartyTime:self.endSlider.value
//                                          logoPage:self.pageControll.currentPage
//                                         logoImage:imageView.image
//                                   descriptionText:self.textView.text];
    
//    NSMutableArray* arrayWithParties = [[NSMutableArray alloc] init];
//    
//    NSData* dataParties = [[NSUserDefaults standardUserDefaults] objectForKey:kParties];
//    if(dataParties){
//        arrayWithParties = [NSKeyedUnarchiver unarchiveObjectWithData:dataParties];
//    }
//    
//    [arrayWithParties addObject:party];
//    
//    dataParties = nil;
//    dataParties = [NSKeyedArchiver archivedDataWithRootObject:arrayWithParties];
//    [[NSUserDefaults standardUserDefaults] setObject:dataParties forKey:kParties];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)saveChangesToCurrentParty{
    
    [[PMRCoreDataManager sharedStore] deletePartyWithName:self.currentParty.name completion:^(BOOL success) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        
        NSDate* date = [dateFormatter dateFromString:self.chooseDateButton.titleLabel.text];
        PMRParty* party = [[PMRParty alloc] initWithPartyID:@""
                                                       name:self.paratyNameTextField.text
                                                  startDate:[self getDateWithSliderValue:self.startSlider.value]
                                                    endDate:[self getDateWithSliderValue:self.endSlider.value]
                                              logoImageName:[self.arrayWithImageNames objectAtIndex:self.pageControll.currentPage]
                                            descriptionText:self.textView.text
                                               creationDate:date
                                           modificationDate:nil
                                                  creatorID:nil
                                                   latitude:nil
                                                 longtitude:nil];
        
        [[PMRCoreDataManager sharedStore] addNewParty:party completion:^(BOOL success) {
            if(success){
            }
        }];

    }];
    
    //NSArray* parties = [[NSArray alloc] init];
    //NSData* dataParties = [[NSUserDefaults standardUserDefaults] objectForKey:kParties];
    //parties = [NSKeyedUnarchiver unarchiveObjectWithData:dataParties];
//    parties = [[PMRCoreDataManager sharedStore] getParties];
//    PMRParty* party = [parties objectAtIndex:self.indexParty];
//    
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    
//    party.name = self.paratyNameTextField.text;
//    party.date = [dateFormatter dateFromString:self.chooseDateButton.titleLabel.text];
//    party.startParty = self.startSlider.value;
//    party.endParty = self.endSlider.value;
//    party.logoPage = self.pageControll.currentPage;
//    party.logoImage = [(UIImageView*)[self.scrollView.subviews objectAtIndex:self.pageControll.currentPage] image];
//    party.descriptionText = self.textView.text;

    
//    dataParties = nil;
//    dataParties = [NSKeyedArchiver archivedDataWithRootObject:parties];
//    [[NSUserDefaults standardUserDefaults] setObject:dataParties forKey:kParties];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Choose location button

- (IBAction)actionChooseLocationButtonTouched:(UIButton *)sender {
    [self showCircleInView:sender];
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
        if([self isDataPartyOK]){
            [self saveParty];
            EMPartyCreatedViewController* vc = segue.destinationViewController;
            vc.navCont = self.navigationController;
            //[self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
