//
//  EMSelectFriendsViewController.h
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/20/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSelectFriendsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* checkedFriends;

@end
