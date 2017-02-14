//
//  EMRegisterViewController.h
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMRegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@end
