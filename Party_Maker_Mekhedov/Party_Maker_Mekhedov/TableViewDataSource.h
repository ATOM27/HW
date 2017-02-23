//
//  TableViewDataSource.h
//  CoreDataMagic
//

@import Foundation;
@import UIKit;
@import CoreData;

@interface TableViewDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, getter=isPaused) BOOL paused;
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, weak) UITableView *tableView;


- (instancetype)initWithTableView:(UITableView*)tableView
                          context:(NSManagedObjectContext*)context;

- (NSManagedObject*)objectAtIndex:(NSIndexPath*)indexPath;
- (NSFetchRequest*)fetchRequest;

- (void)configureCell:(id)cell  withObject:(NSManagedObject*)object;

@end
