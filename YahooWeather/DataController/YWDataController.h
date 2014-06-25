//
//  YWDataController.h
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWLocationInfo.h"

@class DataOperationNC;

@interface YWDataController : NSObject{
    
    YWLocationInfo *currentLocationInfo;
    NSMutableArray *recentVisitedPlaces;
    NSString *resourcePathForRVP;
    
    DataOperationNC* dataOperation;

}



+(YWDataController*)shareDInstance;

-(void)getLocationInformation :(NSString*)locationInformation;
-(void)getWeatherInformationForLocationWithWoeid: (NSString*)woeid withCityName:(NSString*)cityName;
-(void)resetDetails;
-(NSArray*)getRecentlyVistedPlaces;


@end
