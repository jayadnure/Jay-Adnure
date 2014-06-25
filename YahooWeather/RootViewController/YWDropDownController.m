//
//  YWDropDownController.m
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import "YWDropDownController.h"

@interface YWDropDownController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UITableView *dropDownTableView;
}

@end

@implementation YWDropDownController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDataArray:(NSMutableArray *)dataArray_{
    
    _dataArray =dataArray_;
    
    [dropDownTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdent  = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        
    }
    
    if (indexPath.row <=self.dataArray.count){
        NSString *state = [[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"state"] valueForKey:@"sample_text"];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@ %@",[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"city"] valueForKey:@"sample_text"],state,[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"countrycode"] valueForKey:@"sample_text"]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if ([self.delegate respondsToSelector:@selector(didSelectLocationForWeatherInfo:withCityName:)]) {
        
        if (indexPath.row <=self.dataArray.count)
            [self.delegate didSelectLocationForWeatherInfo:[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"woeid"] valueForKey:@"sample_text"]withCityName:[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"city"] valueForKey:@"sample_text"]];
    }
}

@end
