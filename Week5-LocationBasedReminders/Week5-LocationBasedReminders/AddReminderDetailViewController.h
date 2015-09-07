//
//  AddReminderDetailViewController.h
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 9/3/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Reminder.h"


@interface AddReminderDetailViewController : UIViewController

@property (weak, nonatomic) NSString *latitude;
@property (weak, nonatomic) NSString *longitude;
@property (strong,nonatomic) PFGeoPoint *geoPoint;


@end
