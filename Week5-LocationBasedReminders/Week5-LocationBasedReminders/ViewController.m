//
//  ViewController.m
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 8/31/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)leftButton:(id)sender;
- (IBAction)midButton:(id)sender;
- (IBAction)rightButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
 
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)leftButton:(id)sender {
  //Hometown address in Huntington, WV
   [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(38.4340, -82.4010), 100, 100) animated:true];
}

- (IBAction)midButton:(id)sender {
   //Denison University in Granville, OH
   [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.0706, -82.5226), 100, 100) animated:true];
}

- (IBAction)rightButton:(id)sender {
  //Aspira Apartments in Seattle, WA
   [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6160, -122.3333), 100, 100) animated:true];
}
@end
