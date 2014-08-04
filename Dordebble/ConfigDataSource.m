//
//  ConfigDataSource.m
//  Dordebble
//
//  Created by Daniel Vela on 04/08/14.
//  Copyright (c) 2014 veladan. All rights reserved.
//

#import "ConfigDataSource.h"

@implementation ConfigDataSource


- (instancetype)init {
    self.data = @[@{@"placeholder": @"Ex: http://redmine.server.com", @"title":@"Server"},
                  @{@"placeholder": @"Username or mail", @"title":@"User"},
                  @{@"placeholder": @"Base64 string", @"title":@"API Key"}];
    self.values = [NSMutableArray new];

    // Load data from UserInfo
    if ([OSSystem existObjectInConfiguration:@"RedmineConfig"]) {
        NSDictionary* config = (NSDictionary*)[OSSystem loadFromConfig:@"RedmineConfig"];

        [self.values addObject:config[@"ServerURL"]];
        [self.values addObject:config[@"UserLogin"]];
        [self.values addObject:config[@"APIKey"]];
    }
    return self;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.row][@"title"];
}

- (NSString *)valueForIndexPath:(NSIndexPath *)indexPath {
    return self.values[indexPath.row];
}

- (void)setValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath {

    NSDictionary* configInmutable = [OSSystem loadFromConfig:@"RedmineConfig"];

    NSMutableDictionary * config;
    if (configInmutable == nil) {
        config = [NSMutableDictionary new];
    }else {
        config = [configInmutable mutableCopy];
    }
    
    switch (indexPath.row) {
        case 0:
            config[@"ServerURL"] = value;
            break;
        case 1:
            config[@"UserLogin"] = value;
            break;
        case 2:
            config[@"APIKey"] = value;
            break;

        default:
            break;
    }
    [OSSystem createObjectInConfiguration:config forKey:@"RedmineConfig"];
}


- (NSString *)placeholderForIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.row][@"placeholder"];
}

- (NSString *)titleForSection:(NSInteger)section {
    return @"Redmine";
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (NSInteger)numberOfSections {
    return 1;
}

@end
