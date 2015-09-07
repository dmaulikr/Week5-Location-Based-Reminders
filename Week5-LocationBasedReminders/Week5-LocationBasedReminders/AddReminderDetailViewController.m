//
//  AddReminderDetailViewController.m
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 9/3/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import "AddReminderDetailViewController.h"
#import "Reminder.h"
#import "Constants.h"

@interface AddReminderDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *latValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *longValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation AddReminderDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Add Reminder";
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(processDone)];
  self.latValueLabel.text = _latitude;
  self.longValueLabel.text = _longitude;
  
}

- (void) processDone
{
  //create Reminder object
  Reminder *reminder = [[Reminder alloc] initWithClassName:@"Reminder"];
  reminder.user = [PFUser currentUser];
  reminder.name = self.nameTextField.text;
  
  PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude: [_latitude doubleValue] longitude:[_longitude doubleValue]];
  reminder.geoPoint = geoPoint;

  [reminder saveInBackground];
  
   NSDictionary *userInfo = [NSDictionary dictionaryWithObject:reminder forKey:@"Reminder"];

  [[NSNotificationCenter defaultCenter] postNotificationName:kRegionAdded object:self userInfo:userInfo];
  [self.navigationController popViewControllerAnimated:true];

}



@end
