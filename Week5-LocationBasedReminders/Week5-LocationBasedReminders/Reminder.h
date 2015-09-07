//
//  Reminder.h
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 9/6/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import <Parse/Parse.h>

@interface Reminder : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong,nonatomic) PFUser *user;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) PFGeoPoint *geoPoint;



@end
