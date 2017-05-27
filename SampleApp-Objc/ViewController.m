//
//  ViewController.m
//  SampleApp-Objc
//
//  Created by Matt Smollinger on 5/25/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

#import "ViewController.h"
@import Mapzen_ios_sdk;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  MZMapViewController *mapView = [[MZMapViewController alloc] init];
  [self.view addSubview:mapView.view];
  NSLayoutConstraint *top = [mapView.view.topAnchor constraintEqualToAnchor:self.view.topAnchor];
  NSLayoutConstraint *left = [mapView.view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor];
  NSLayoutConstraint *right = [mapView.view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor];
  NSLayoutConstraint *bottom = [mapView.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
  [NSLayoutConstraint activateConstraints:@[top, left, right, bottom]];
  [mapView loadStyleAsync:MapStyleWalkabout error:nil onStyleLoaded:^(enum MapStyle style) {
    (void)[mapView showCurrentLocation:YES];
    (void)[mapView showFindMeButon:YES];
  }];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
