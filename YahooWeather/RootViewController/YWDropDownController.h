//
//  YWDropDownController.h
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YWDropDownControllerDelegate <NSObject>

-(void)didSelectLocationForWeatherInfo:(NSString*)cityCode withCityName:(NSString*)cityName;

@end

@interface YWDropDownController : UIViewController


@property (nonatomic,strong) id<YWDropDownControllerDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
