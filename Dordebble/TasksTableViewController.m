//
//  TasksTableViewController.m
//  Dordebble
//
//  Created by Daniel Vela on 24/07/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "TasksTableViewController.h"
#import "TimeViewController.h"

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

    self.config = [OSSystem loadFromConfig:@"RedmineConfig"];
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
          self.projects = [NSMutableDictionary dictionary];
          for (NSDictionary* issue in response[@"issues"]) {
              NSMutableArray* arr = [self.projects objectForKey:issue[@"project"][@"name"]];
              if (arr == nil) {
                  arr = [NSMutableArray array];
                  self.projects[issue[@"project"][@"name"]] = arr;
              }
              [arr addObject:issue];
          }
          [self.tableView reloadData];
      }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.projects allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = [self.projects allKeys][section];
    return [self.projects[key] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];

    NSString* key = [self.projects allKeys][indexPath.section];
    NSDictionary* issue = self.projects[key][indexPath.row];

    UILabel* text = (UILabel*)[cell viewWithTag:1];
    text.text = issue[@"subject"];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.projects allKeys][section];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    TimeViewController* controller = (TimeViewController*)segue.destinationViewController;
    NSString* key = [self.projects allKeys][indexPath.section];
    NSDictionary* issue = self.projects[key][indexPath.row];
    controller.issue = issue;
}


- (IBAction)refresh:(id)sender {
    [self downloadDataFromRedmine];
}

@end
