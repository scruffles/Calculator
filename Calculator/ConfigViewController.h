#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(IBAction)configDone:(id)sender;

@end
