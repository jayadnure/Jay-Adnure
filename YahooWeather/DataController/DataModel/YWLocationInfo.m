//
//  YWLocationInfo.m
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import "YWLocationInfo.h"
#import "YWDayInfo.h"


@implementation YWLocationInfo


-(id)initWithInforMation :(NSDictionary*)infoDict{
    
    self = [super init];
    
    if (self) {
        
        _locationTitle = [infoDict valueForKey:@""];
    }
    
    return self;
}


-(void)populateDetailsOfWeather :(NSDictionary*)infoDict{
    
    _locationTitle = [[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"description"] valueForKey:@"sample_text"];
    
    NSDictionary *itemDetails = [[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"yweather:location"];
    
    _city = [itemDetails valueForKey:@"city"];
    _country = [itemDetails valueForKey:@"country"];
    _region = [itemDetails valueForKey:@"region"];
    
    itemDetails = [[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"item"] valueForKey:@"yweather:condition"];
    
    _currentTemperature =[NSString stringWithFormat:@"%@°",[itemDetails valueForKey:@"temp"]];
    _climateStatus =[itemDetails valueForKey:@"text"];
    _date =[itemDetails valueForKey:@"date"];
 
    
    _forecastArray = [[NSMutableArray alloc] init];
    
    NSArray *forecastArray = [[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"item"] valueForKey:@"yweather:forecast"];
    
    for (NSDictionary *infoDict in forecastArray) {
        
        [_forecastArray addObject:[[YWDayInfo alloc] initWithInforMation:infoDict]];
        
    }
    
    _sunRise = [[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"yweather:astronomy"] valueForKey:@"sunrise"];
    _sunSet  = [[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"yweather:astronomy"] valueForKey:@"sunset"];;
    _windSpeed =[NSString stringWithFormat:@"%@ Km/h W",[[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"yweather:wind"] valueForKey:@"speed"]];
    _visibilty =[NSString stringWithFormat:@"%@ Km",[[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"yweather:atmosphere"] valueForKey:@"visibility"]];
    _humidity =[NSString stringWithFormat:@"%@ %%",[[[[infoDict valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"yweather:atmosphere"] valueForKey:@"humidity"]];

}

//@property (nonatomic,strong) NSString *highTemp;
//@property (nonatomic,strong) NSString *lowTemp;

@end
