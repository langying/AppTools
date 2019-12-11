//
//  CLLocation+Additions.m
//  TBSport
//
//  Created by weixing.jwx on 15/4/28.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "CLLocation+Additions.h"

@implementation CLLocation(Additions)

+ (CLCoordinateRect)boundingBoxContainingLocations:(NSArray*)locations; {
    CLCoordinateRect result;
    
    result.topLeft = ((CLLocation*)[locations objectAtIndex:0]).coordinate;
    result.bottomRight = result.topLeft;
    
    for (int i=1; i<[locations count]; i++) {
        CLLocationCoordinate2D coord = ((CLLocation*)[locations objectAtIndex:i]).coordinate;
        result.topLeft.latitude = MAX(result.topLeft.latitude, coord.latitude);
        result.topLeft.longitude = MIN(result.topLeft.longitude, coord.longitude);
        result.bottomRight.latitude = MIN(result.bottomRight.latitude, coord.latitude);
        result.bottomRight.longitude = MAX(result.bottomRight.longitude, coord.longitude);
    }
    
    return result;
}

+ (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoord toCoordinate:(CLLocationCoordinate2D)toCoord {
    CLLocation* location = [CLLocation.alloc initWithLatitude:fromCoord.latitude longitude:fromCoord.longitude];
    CLLocationDistance dist = [location distanceFromCoordinate:toCoord];
    return dist;
}

- (CLLocationCoordinate2D)marsCoordinate {
    return [CLLocation transformToMars:self];
}

- (CLLocationSpeed)speedTravelledFromLocation:(CLLocation*)fromLocation {
    NSTimeInterval tInterval = [self.timestamp timeIntervalSinceDate:fromLocation.timestamp];
    double distance = [self distanceFromLocation:fromLocation];
    double speed = (distance / tInterval);
    return speed;
}

- (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoord {
    double earthRadius = 6371.01; // Earth's radius in Kilometers
    
    // Get the difference between our two points then convert the difference into radians
    double nDLat = (fromCoord.latitude - self.coordinate.latitude) * kDegreesToRadians;
    double nDLon = (fromCoord.longitude - self.coordinate.longitude) * kDegreesToRadians;
    
    double fromLat =  self.coordinate.latitude * kDegreesToRadians;
    double toLat =  fromCoord.latitude * kDegreesToRadians;
    
    double nA =	pow ( sin(nDLat/2), 2 ) + cos(fromLat) * cos(toLat) * pow ( sin(nDLon/2), 2 );
    
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = earthRadius * nC;
    
    return nD * 1000; // Return our calculated distance in meters
}

#pragma mark - 火星坐标系转换
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
+ (CLLocationCoordinate2D)transformToMars:(CLLocation*)location {
    //是否在中国大陆之外
    if ([[self class] outOfChina:location]) {
        return location.coordinate;
    }
    double dLat = [[self class] transformLatWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
    double dLon = [[self class] transformLonWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
    double radLat = location.coordinate.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    return CLLocationCoordinate2DMake(location.coordinate.latitude + dLat, location.coordinate.longitude + dLon);
}
+ (BOOL)outOfChina:(CLLocation *)location {
    if (location.coordinate.longitude < 72.004 || location.coordinate.longitude > 137.8347) {
        return YES;
    }
    if (location.coordinate.latitude < 0.8293 || location.coordinate.latitude > 55.8271) {
        return YES;
    }
    return NO;
}
+ (double)transformLatWithX:(double)x y:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320.0 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}
+ (double)transformLonWithX:(double)x y:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
@end
