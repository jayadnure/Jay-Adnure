//
//  YWLocationInfo.h
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWLocationInfo : NSObject

@property (nonatomic,strong) NSString *locationTitle;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *region;

/*Climate Inforamtion*/
@property (nonatomic,strong) NSString *highTemp;
@property (nonatomic,strong) NSString *lowTemp;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *climateStatus;
@property (nonatomic,strong) NSString *currentTemperature;
@property (nonatomic,strong) NSString *sunRise;
@property (nonatomic,strong) NSString *sunSet;
@property (nonatomic,strong) NSString *windSpeed;
@property (nonatomic,strong) NSString *visibilty;
@property (nonatomic,strong) NSString *humidity;



@property (nonatomic,strong) NSMutableArray *forecastArray;


-(id)initWithInforMation :(NSDictionary*)infoDict;
-(void)populateDetailsOfWeather :(NSDictionary*)infoDict;


@end
