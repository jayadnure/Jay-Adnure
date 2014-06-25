//
//  YWDayInfo.h
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWDayInfo : NSObject


@property (nonatomic,strong) NSString *highTemp;
@property (nonatomic,strong) NSString *lowTemp;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *climateStatus,*code;


-(id)initWithInforMation :(NSDictionary*)infoDict;

@end
