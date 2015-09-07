//
//  ViewController.h
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 8/31/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate> {
  }
- (void)getUserLocation;
- (void)presentLocationServicesAlert;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)queryForRegions;
@end

