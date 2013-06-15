#import "ConfigViewController.h"
#import "ThemeLoader.h"

@interface ConfigViewController ()
@end

#define ALL_RESULTS_KEY @"ALL"

@implementation ConfigViewController {
@private
    NSArray *themes;
    UITableView *_tableView;
}

@synthesize tableView = _tableView;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [themes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    cell.textLabel.text = [[themes objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * id = [themes[indexPath.row] valueForKey:@"id"];
    [[ThemeLoader instance] setCurrentTheme: id];
//    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    themes = [[ThemeLoader instance] getAllThemes];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[[ThemeLoader instance]getCurrentThemeIndex] inSection:0] animated:false scrollPosition:UITableViewScrollPositionTop];
}


- (IBAction)configDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
