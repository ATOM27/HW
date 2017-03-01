//
//  EMLoginViewController.m
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/6/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMLoginViewController.h"
#import "EMHTTPManager.h"
#import "UIViewController+Alert.h"
#import "EMPartyListViewController.h"

@interface EMLoginViewController ()

@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;


@property(strong, nonatomic) NSString* creatorID;

@end

NSString* const tabBarIdentifier = @"TabBarIdentifier";

@implementation EMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    UIView* paddingLogginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.emailTextField.leftView = paddingLogginView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView* paddingPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];

    self.passwordTextField.leftView = paddingPasswordView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email"
                                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                                  }
                                                      ];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password"
                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:76.f/255.f green:82.f/255.f blue:92.f/255.f alpha:1.f],
                                                                                             }
                                                 ];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:self.emailTextField]){
        [self.passwordTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)actionSignInTouched:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[EMHTTPManager sharedManager] loginWithEmail:self.emailTextField.text
                                        password:self.passwordTextField.text
                                      completion:^(NSDictionary *response, NSError *error) {
                                          if(error){
                                              NSLog(@"%@", [error localizedDescription]);
                                          }else{
                                              if(![response valueForKey:@"error"]){
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [[NSUserDefaults standardUserDefaults] setObject:[[response valueForKey:@"id"] stringValue] forKey:@"creatorID"];
                                                      [[NSUserDefaults standardUserDefaults] setObject:[response valueForKey:@"accessToken"] forKey:@"accessToken"];
                                                      [self performSegueWithIdentifier:tabBarIdentifier sender:self];
                                                  });
                                              }else{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self alertWithTitle:@"Ops!" message:@"Wrong name or password"];
                                                  });
                                              }
                                          }
                                          sender.userInteractionEnabled = YES;
                                      }];
}


@end
