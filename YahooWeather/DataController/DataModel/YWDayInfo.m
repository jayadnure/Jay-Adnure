//
//  YWDayInfo.m
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import "YWDayInfo.h"

@implementation YWDayInfo

-(id)initWithInforMation :(NSDictionary*)infoDict{
    
    self = [super init];
    
    if (self) {
    
        _climateStatus =[infoDict valueForKey:@"text"];
        _day =[infoDict valueForKey:@"day"];
        _highTemp =[NSString stringWithFormat:@"%@°",[infoDict valueForKey:@"high"]];
        _lowTemp =[NSString stringWithFormat:@"%@°",[infoDict valueForKey:@"low"]];
        _code =[infoDict valueForKey:@"code"];
    }
    
    return self;
}

@end
