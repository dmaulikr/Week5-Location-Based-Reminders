//
//  Reminder.m
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 9/6/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import "Reminder.h"
#import <Parse/PFObject+Subclass.h>

@interface Reminder()

@end

@implementation Reminder

+ (void)load {
  [self registerSubclass];
}

@dynamic name;
@dynamic user;
@dynamic geoPoint;

+ (NSString * __nonnull)parseClassName {
  return @"Reminder";
}


@end
