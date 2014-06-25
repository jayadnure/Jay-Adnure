//
//  YWForecatsCustomCell.m
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import "YWForecatsCustomCell.h"

@implementation YWForecatsCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDayInfo:(YWDayInfo *)dayInfo_{
    
    [dayLabel setText:dayInfo_.day];
    [highLabel setText:dayInfo_.highTemp];
    [lowLabel setText:dayInfo_.lowTemp];
    [conditionImageView setImage:[UIImage imageNamed:dayInfo_.code]];
}

@end
