//
//  YWForecatsCustomCell.h
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWDayInfo.h"

@interface YWForecatsCustomCell : UITableViewCell{
    
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *lowLabel;
    IBOutlet UILabel *highLabel;
    IBOutlet UIImageView *conditionImageView;
    
}



@property (nonatomic,strong) YWDayInfo *dayInfo;

@end
