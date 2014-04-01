//
//  GoogleMapsKit.m
//  GoogleMapsKitDemo
//
//  Created by Fawkes Wei on 12/14/12.
//  Copyright (c) 2012 fawkeswei. All rights reserved.
//

#import "GoogleMapsKit.h"
#import "NSString+GoogleMapsKit.h"

#define kCONST_PREFIX @"comgooglemaps://?"

NSString * const GoogleMapsDirectionsMode_toString[] = {
  @"driving",
  @"transit",
  @"walking"
};


@implementation GoogleMapsKit

+ (BOOL)isGoogleMapsInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kCONST_PREFIX]];
}

+ (void)showMapWithCenter:(CLLocationCoordinate2D )centerCoordinate {
    [GoogleMapsKit showMapWithCenter:centerCoordinate zoom:-1];
}

+ (void)showMapWithCenter:(CLLocationCoordinate2D )centerCoordinate zoom:(NSInteger )zoom {
    [GoogleMapsKit showMapWithCenter:centerCoordinate zoom:zoom mapMode:GoogleMapsModeDefault view:GoogleMapsViewClearAll];
}

+ (void)showMapWithCenter:(CLLocationCoordinate2D )centerCoordinate zoom:(NSInteger )zoom mapMode:(GoogleMapsMode )mapMode view:(GoogleMapsView )view {
    
    NSMutableString *urlString = [GoogleMapsKit _parseCommonParamsWithCenter:centerCoordinate zoom:zoom mapMode:mapMode view:view];
    
    if (urlString) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

+ (void)showMapWithSearchKeyword:(NSString *)keyword {
    [GoogleMapsKit showMapWithSearchKeyword:keyword withCenter:kCLLocationCoordinate2DInvalid zoom:-1];
}

+ (void)showMapWithSearchKeyword:(NSString *)keyword withCenter:(CLLocationCoordinate2D )centerCoordinate {
    [GoogleMapsKit showMapWithSearchKeyword:keyword withCenter:centerCoordinate zoom:-1];
}

+ (void)showMapWithSearchKeyword:(NSString *)keyword withCenter:(CLLocationCoordinate2D )centerCoordinate zoom:(NSInteger )zoom {
    [GoogleMapsKit showMapWithSearchKeyword:keyword withCenter:centerCoordinate zoom:zoom mapMode:GoogleMapsModeDefault view:GoogleMapsViewClearAll];
}

+ (void)showMapWithSearchKeyword:(NSString *)keyword withCenter:(CLLocationCoordinate2D )centerCoordinate zoom:(NSInteger )zoom mapMode:(GoogleMapsMode )mapMode view:(GoogleMapsView )view {
    
    NSMutableString *urlString = [GoogleMapsKit _parseCommonParamsWithCenter:centerCoordinate zoom:zoom mapMode:mapMode view:view];
    [urlString appendFormat:@"&q=%@", keyword.urlEncode];
    
    if (urlString) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

+(void) showMapWithDirectionsForStartAddress:(NSString *) saddr destinationAddress:(NSString *) daddr directionsMode:(GoogleMapsDirectionsMode) directionsMode {

    NSString *start = nil;

    NSString *destination = nil;

    if ([saddr length] > 0)
        start = [NSString stringWithFormat:@"saddr=%@", [saddr urlEncode]];
    else
        start = @"saddr="; // leave it blank and google maps will use current location

    if ([daddr length] > 0)
        destination = [NSString stringWithFormat:@"daddr=%@", [daddr urlEncode]];
    else
        destination = @"";

    [self showMapDirectionsWithStart:start destination:destination directionsMode:directionsMode];

}

+(void)showMapWithDirectionsForStartingPointCoordinate:(CLLocationCoordinate2D)saddr endPointCoordinate:(CLLocationCoordinate2D)daddr directionsMode:(GoogleMapsDirectionsMode) directionsMode {

    NSString * start = nil;

    NSString * destination = nil;

    if (CLLocationCoordinate2DIsValid(saddr) && saddr.latitude != 0 && saddr.longitude != 0)
        start = [NSString stringWithFormat:@"saddr=%f,%f", saddr.latitude, saddr.longitude];
    else
        start = @"saddr="; // leave it blank and google maps will use current location

    if (CLLocationCoordinate2DIsValid(daddr))
        destination = [NSString stringWithFormat:@"daddr=%f,%f", daddr.latitude, daddr.longitude];

    [self showMapDirectionsWithStart:start destination:destination directionsMode:directionsMode];

}

+(void) showMapDirectionsWithStart:(id) saddr destination:(id) daddr directionsMode:(GoogleMapsDirectionsMode) directionsMode {

    NSMutableString *urlString = [NSMutableString stringWithString:kCONST_PREFIX];

    NSMutableArray *args = [NSMutableArray array];

    if ([saddr length] > 0)
        [args addObject:saddr];

    if ([daddr length] > 0)
        [args addObject:daddr];

    [args addObject:[NSString stringWithFormat:@"directionsmode=%@", GoogleMapsDirectionsMode_toString[directionsMode]]];

    for (NSInteger i = 0; i < [args count]; i++) {

        NSString *arg = [args objectAtIndex:i];

        [urlString appendString:arg];

        if (i < [args count] - 1)
            [urlString appendString:@"&"];
    }

    if (urlString)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

}
#pragma mark - Private Methods

+ (NSMutableString *)_parseCommonParamsWithCenter:(CLLocationCoordinate2D )centerCoordinate zoom:(NSInteger )zoom mapMode:(GoogleMapsMode )mapMode view:(GoogleMapsView )view {
    NSMutableString *urlString = [NSMutableString stringWithString:kCONST_PREFIX];
    
    if (CLLocationCoordinate2DIsValid(centerCoordinate)) {
        [urlString appendFormat:@"center=%f,%f", centerCoordinate.latitude, centerCoordinate.longitude];
    }
    
    if (zoom > 0) {
        [urlString appendFormat:@"&zoom=%ld", (long)zoom];
    }
    
    switch (mapMode) {
        case GoogleMapsModeStandard:
            [urlString appendString:@"&mapmode=standard"];
            break;
        case GoogleMapsModeStreetView:
            [urlString appendString:@"&mapmode=streetview"];
            break;
        case GoogleMapsModeDefault:
            break;
        default:
            break;
    }
    
    switch (view) {
        case GoogleMapsViewSatellite:
            [urlString appendString:@"&views=satellite"];
            break;
        case GoogleMapsViewTraffic:
            [urlString appendString:@"&views=traffic"];
            break;
        case GoogleMapsViewTransit:
            [urlString appendString:@"&views=transit"];
            break;
        case GoogleMapsViewClearAll:
            break;
        default:
            break;
    }
    return urlString;
}


@end
