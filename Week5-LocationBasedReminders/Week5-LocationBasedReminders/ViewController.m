//
//  ViewController.m
//  Week5-LocationBasedReminders
//
//  Created by Joey Nessif on 8/31/15.
//  Copyright (c) 2015 Joey Nessif. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "AddReminderDetailViewController.h"


@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;


- (IBAction)userLocButton:(id)sender;
- (IBAction)leftButton:(id)sender;
- (IBAction)midButton:(id)sender;
- (IBAction)rightButton:(id)sender;



@end

@implementation ViewController

BOOL lsON = FALSE;
BOOL lsAllowed = FALSE;
NSString *selLatitude;
NSString *selLongitude;

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.mapView setMapType: MKMapTypeHybrid];
  self.mapView.delegate = self;
 
  //initial mapView is of downtown Seattle
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6097, -122.3331), 5550, 5550) animated:true];
  
  [self setupLongPress];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (nil == self.locationManager) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self determineLocationServicesStatus];
    [self queryForRegions];
  }
  
 //If Location Services is ON and Allowed
  if (lsON && lsAllowed) {
   
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionAdded:) name:kRegionAdded object:nil];
  }
  
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - IBActions 

- (IBAction)userLocButton:(id)sender {
  [self determineLocationServicesStatus];
  //If Location Services is ON and Allowed
  if (lsON && lsAllowed) {
    [self getUserLocation];
    self.mapView.showsUserLocation = true;
  } else {
    [self presentLocationServicesAlert];
  }
}

- (IBAction)leftButton:(id)sender {
  //Hometown address in Huntington, WV
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(38.4340, -82.4010), 250, 250) animated:true];
}

- (IBAction)midButton:(id)sender {
   //Denison University in Granville, OH
     [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.0706, -82.5226), 250, 250) animated:true];
}

- (IBAction)rightButton:(id)sender {
  //Aspira Apartments in Seattle, WA
     [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6160, -122.3333), 250, 250) animated:true];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
     //CLLocation* location = [locations lastObject];
    // NSLog(@"lat: %f, long: %f",location.coordinate.latitude, location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  
  notification.alertTitle = @"You've Arrived";
  notification.alertBody = @"Congratulations!";
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
  NSLog(@"I'm monitoring region: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
  NSLog(@"I FAILED to monitor region: %@", region);

}


#pragma mark - User-defined functions

- (void)determineLocationServicesStatus
{
  //Check that Location Services are enabled
  if ([CLLocationManager locationServicesEnabled]) {
    lsON = TRUE;
    //check the authorization status for Location Services
    [self determineLocationServicesAuthorization];
  } else {
    //present Alert since Location Services is totally off
    [self presentLocationServicesAlert];
  }
  
}

- (void)determineLocationServicesAuthorization
{
  
  switch ([CLLocationManager authorizationStatus]) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self.locationManager startUpdatingLocation];
      lsAllowed = TRUE;
      break;
    case kCLAuthorizationStatusAuthorizedAlways:
      [self.locationManager startUpdatingLocation];
      lsAllowed = TRUE;
      break;
    case kCLAuthorizationStatusRestricted:
      [self presentLocationServicesAlert];
      lsAllowed = FALSE;
      break;
    case kCLAuthorizationStatusDenied:
      [self presentLocationServicesAlert];
      lsAllowed = FALSE;
      break;
    case kCLAuthorizationStatusNotDetermined:
      [self.locationManager requestAlwaysAuthorization];
      break;
    default:
      break;
  }

}

- (void)presentLocationServicesAlert
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLocationServicesTitle message:kLocationServicesMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  [alert show];
}

- (void)getUserLocation
{
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.distanceFilter = 500;
  [self.locationManager startUpdatingLocation];
  
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 1000, 1000) animated:true];
  
  [self.locationManager stopUpdatingLocation];
  
}

-(void)setupLongPress{
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(executeLongPress:)];
  longPress.minimumPressDuration = .5; //seconds
  longPress.delegate = self;
  [self.mapView addGestureRecognizer:longPress];
}

-(void)executeLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
    return;
  }
  CGPoint p = [gestureRecognizer locationInView:self.mapView];
  CLLocationCoordinate2D coordinate = [self.mapView convertPoint:p toCoordinateFromView:self.mapView];
  
  
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
  annotation.title = @"Long Press Location";
 
  NSString *coordLat = [NSString stringWithFormat:@"%f", coordinate.latitude];
  NSString *coordLong = [NSString stringWithFormat:@"%f", coordinate.longitude];
  selLatitude = coordLat;
  selLongitude = coordLong;
  
  annotation.subtitle = @"Lat: ";
  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLat];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:@"  Long:"];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLong];
  
  [self.mapView addAnnotation:annotation];
  
}

- (void)queryForRegions
{
  
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
    
    PFQuery *reminderQuery = [PFQuery queryWithClassName:@"Reminder"];
    [reminderQuery findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
      
      NSLog(@"%lu", (unsigned long)reminders.count);
      
      for (Reminder *reminder in reminders) {
        [self drawOverlay:reminder];
      }
    }];
  }
}

-(void) drawOverlay:(Reminder *)reminder
{
  CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(reminder.geoPoint.latitude, reminder.geoPoint.longitude) radius:60 identifier: reminder.name];
  
  [self.locationManager startMonitoringForRegion:region];
  MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(reminder.geoPoint.latitude, reminder.geoPoint.longitude) radius:60];
  
  [self.mapView addOverlay:circle];
}

-(void)regionAdded:(NSNotification *)notification
{
  NSDictionary *userInfo = notification.userInfo;
  if (userInfo) {
    
    Reminder *reminder = userInfo[@"Reminder"];
    [self drawOverlay:reminder];
  }

}


#pragma mark - MapView Delegate

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
  [self performSegueWithIdentifier:@"ShowAddReminder" sender:self];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  NSString *reuseID = @"AnnotationView";
  
  MKPinAnnotationView *pinView =(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
  
  if (!pinView) {
    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
  } else {
    pinView.annotation = annotation;
  }
  
  pinView.animatesDrop = true;
  pinView.pinColor = MKPinAnnotationColorGreen;
  pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  pinView.canShowCallout = YES;
  
  return pinView;
  
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  
  circleRenderer.strokeColor = [UIColor redColor];
  circleRenderer.lineWidth = 5;
  circleRenderer.fillColor = [UIColor yellowColor];
  circleRenderer.alpha = 1.0;
  
  return circleRenderer;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([[segue identifier] isEqualToString:@"ShowAddReminder"]) {
    AddReminderDetailViewController *addReminder = [segue destinationViewController];
    addReminder.latitude = selLatitude;
    addReminder.longitude = selLongitude;

  }
  
}



@end
