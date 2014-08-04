//
//  ConfigTableViewController.m
//  Dordebble
//
//  Created by Daniel Vela on 04/08/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "ConfigTableViewController.h"

#import "ConfigDataSource.h"

@interface ConfigTableViewController ()

@property (nonatomic, strong) id<OSStaticTableDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray* inputs;
@end

@implementation ConfigTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.inputs = [NSMutableArray new];

    self.dataSource = [ConfigDataSource new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataSource titleForSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];

    UILabel* label = (UILabel*)[cell viewWithTag:1];
    label.text = [self.dataSource titleForIndexPath:indexPath];

    UITextField* inputView = (UITextField*)[cell viewWithTag:2];
    if ([self.dataSource respondsToSelector:@selector(placeholderForIndexPath:)]) {
        [inputView setPlaceholder:[self.dataSource placeholderForIndexPath:indexPath]];
    }

    [inputView setText:[self.dataSource valueForIndexPath:indexPath]];

    if ([self.inputs count] <= indexPath.section) {
        [self.inputs insertObject:[NSMutableArray new] atIndex:indexPath.section];
    }
    [self.inputs[indexPath.section] addObject:inputView];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    NSInteger sectionNumber = [self.dataSource numberOfSections];
    for (NSInteger section = 0 ; section < sectionNumber ; section++ ) {
        NSInteger rowNumber = [self.dataSource numberOfRowsInSection:section];
        for (NSInteger row = 0 ; row < rowNumber ; row++ ) {
            NSIndexPath* indePath = [NSIndexPath indexPathForRow:row inSection:section];
            NSString* value = [(UITextField*)self.inputs[section][row] text];
            [self.dataSource setValue:value forIndexPath:indePath];
        }
    }

}


@end
