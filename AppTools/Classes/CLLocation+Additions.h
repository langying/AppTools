//
//  CLLocation+Additions.h
//  TBSport
//
//  Created by weixing.jwx on 15/4/28.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

static const double kDegreesToRadians = M_PI / 180.0;
static const double kRadiansToDegrees = 180.0 / M_PI;

typedef struct {
    CLLocationCoordinate2D topLeft;
    CLLocationCoordinate2D bottomRight;
} CLCoordinateRect;

@interface CLLocation(Additions)

+ (CLCoordinateRect)boundingBoxContainingLocations:(NSArray*)locations;
+ (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoord toCoordinate:(CLLocationCoordinate2D)toCoord;

- (CLLocationCoordinate2D)marsCoordinate;

- (CLLocationSpeed)speedTravelledFromLocation:(CLLocation*)fromLocation;

- (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoord;

@end
