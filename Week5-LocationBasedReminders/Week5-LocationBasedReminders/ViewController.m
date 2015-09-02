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


@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)userLocButton:(id)sender;
- (IBAction)leftButton:(id)sender;
- (IBAction)midButton:(id)sender;
- (IBAction)rightButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.mapView setMapType: MKMapTypeHybrid];
  
  self.mapView.delegate = self;
  [self setupLongPress];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewDidLoad];
  
  if (nil == locationManager) {
    locationManager = [[CLLocationManager alloc] init];
    //Ask permission to use Location Services
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
      [locationManager requestWhenInUseAuthorization];
    }
  }
  
}

- (IBAction)userLocButton:(id)sender {
  [self getUserLocation];
  self.mapView.showsUserLocation = true;

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

- (void)getUserLocation
{
  locationManager.delegate = self;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  
  [locationManager startUpdatingLocation];
  
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 150, 150) animated:true];
  
  [locationManager stopUpdatingLocation];
  
 }

//Brad's code, with modifications - 2 delegate methods below
#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status  {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorizedWhenInUse :
      [locationManager startUpdatingLocation];
      break;
    case kCLAuthorizationStatusAuthorizedAlways :
      [locationManager startUpdatingLocation];
      break;
    default:
      break;
  }
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


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
     CLLocation* location = [locations lastObject];
     NSLog(@"lat: %f, long: %f",location.coordinate.latitude, location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
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
  NSLog(@"pointX: %f, pointY: %f", p.x, p.y);
  
  CLLocationCoordinate2D coordinate = [self.mapView convertPoint:p toCoordinateFromView:self.mapView];
  
  NSLog(@"latitude: %f, longitude: %f", coordinate.latitude, coordinate.longitude);
  
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
  annotation.title = @"Long Press Location";
 
  NSString *coordLat = [NSString stringWithFormat:@"%f", coordinate.latitude];
  NSString *coordLong = [NSString stringWithFormat:@"%f", coordinate.longitude];
  
  annotation.subtitle = @"Lat: ";
  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLat];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:@"  Long:"];
  annotation.subtitle = [annotation.subtitle stringByAppendingString:coordLong];
  
  [self.mapView addAnnotation:annotation];
  
}
@end
