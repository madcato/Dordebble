//
//  TasksTableViewController.m
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "TasksTableViewController.h"

@interface TasksTableViewController ()

@end

@implementation TasksTableViewController

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

    [self downloadDataFromRedmine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Redmine server

-(NSString*)userURL {
    return [NSString stringWithFormat:@"%@/users.json?name=%@",self.config[@"ServerURL"],self.config[@"UserLogin"]];
}

-(NSString*)tasksURL:(NSNumber*)idNumber {
    return [NSString stringWithFormat:@"%@/issues.json?assigned_to_id=%@&status_id=2",self.config[@"ServerURL"],idNumber];
}

- (void)downloadDataFromRedmine {

    self.request = [OSWebRequest webRequest];

    [self.request get:[self userURL]
              headers:@{@"X-Redmine-API-Key": self.config[@"APIKey"],
                        @"Accept": @"application/json"}
          withHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError *error){

              if (error)
              {
                  NSLog(@"%@",error);
                  return;
              }
              NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
              if (error)
              {
                  NSLog(@"%@",error);
                  return;
              }
              NSArray* users = response[@"users"];
              if ([users count] ==1) {
                  NSDictionary* user = users[0];
                  NSNumber* idNumber = user[@"id"];
                  [self downloadTasksFromRedmineForUser:idNumber];
              } else {
                  NSLog(@"Fallo al buscar al usuario");
                  return;
              }


    }];
}

-(void)downloadTasksFromRedmineForUser:(NSNumber*)idNumber {

    self.request = [OSWebRequest webRequest];

    [self.request get:[self tasksURL:idNumber]
          headers:@{@"X-Redmine-API-Key": self.config[@"APIKey"],
                    @"Accept": @"application/json"}
      withHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError *error){

          if (error)
          {
              NSLog(@"%@",error);
              return;
          }
          NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
          if (error)
          {
              NSLog(@"%@",error);
              return;
          }
          self.issues = response[@"issues"];
          [self.tableView reloadData];
      }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.issues.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];

    NSDictionary* issue = self.issues[indexPath.row];

    cell.textLabel.text = issue[@"subject"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)refresh:(id)sender {
    [self downloadDataFromRedmine];
}

@end
