
//
//  YWRootVC.m
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import "YWRootVC.h"
#import "YWDataController.h"
#import "YWLocationInfo.h"
#import "YWForecatsCustomCell.h"
#import "YWDropDownController.h"

#define ZERO 0
#define ForecastTable 0
#define RecentVisitTable 1

static int count = 0 ;

@interface YWRootVC ()<UITableViewDataSource,UITableViewDelegate,YWDropDownControllerDelegate>{
    
    
    YWDropDownController *dropdownController;
    UIPopoverController *popOverController;
    
    
    __weak IBOutlet UITextField *locationSearchTextField;
    __weak IBOutlet UILabel *countryRegoinLabel;
    __weak IBOutlet UILabel *cityLabel;
    __weak IBOutlet UILabel *highTemperature;
    __weak IBOutlet UILabel *lowTemperature;
    __weak IBOutlet UILabel *climateStatus;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *actualTemperatureLabel;
    __weak IBOutlet UILabel *sunRiseLabel;
    __weak IBOutlet UILabel *sunsetLabel;
    __weak IBOutlet UILabel *windSpeed;
    __weak IBOutlet UILabel *visibility;
    __weak IBOutlet UILabel *humidity;
    
    
    NSArray *forecastArray;
    NSArray *recentVisitedPlaces;
    
    __weak IBOutlet UITableView *forecastTableView;
    __weak IBOutlet UITableView *recentVisitTableView;
    
    __weak IBOutlet UIView *windPressureView;
    
    IBOutletCollection(UIView) NSArray *viewCollection;
    __weak IBOutlet UIImageView *sunImageView;
    __weak IBOutlet UIImageView *climateImageView;

    BOOL animating;
}
- (IBAction)locationSearch_touchUpInside:(id)sender;

@end

@implementation YWRootVC

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
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationWeatherInformation:) name:@"Update_Details" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDropDownTable:) name:@"Update_Dropdown" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSpin) name:@"DOWNLOAD_STARTED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSpin) name:@"Download_Completed" object:nil];
    
    [forecastTableView setBackgroundColor:[UIColor clearColor]];
    [recentVisitTableView setBackgroundColor:[UIColor clearColor]];

    
    locationSearchTextField.text =@"Bangalore";
    
    recentVisitedPlaces = [[YWDataController shareDInstance] getRecentlyVistedPlaces];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    [self locationSearch_touchUpInside:Nil];
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Location Search Methods

- (IBAction)locationSearch_touchUpInside:(id)sender {

    if (locationSearchTextField.text.length > ZERO) {
        
        [[YWDataController shareDInstance] resetDetails];
        [[YWDataController shareDInstance] getLocationInformation:locationSearchTextField.text];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Enter Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

}


#pragma mark - View Updation Methods

-(void)updateLocationWeatherInformation :(NSNotification*)notification{
    
    
    if (notification.object) {

        YWLocationInfo *currentLocationInfo = [notification object];
        
        [cityLabel setText:currentLocationInfo.city];
        [countryRegoinLabel setText:[NSString stringWithFormat:@"%@, %@",currentLocationInfo.region,currentLocationInfo.country]];
        [climateStatus setText:currentLocationInfo.climateStatus];
        [actualTemperatureLabel setText:currentLocationInfo.currentTemperature];
        [dateLabel setText:currentLocationInfo.date];
        
        
        
        forecastArray = [currentLocationInfo forecastArray];
        if (forecastArray.count) {
            
            [highTemperature setText:[(YWDayInfo*)[forecastArray objectAtIndex:0]highTemp]];
            [lowTemperature setText:[(YWDayInfo*)[forecastArray objectAtIndex:0]lowTemp]];
            [climateImageView setImage:[UIImage imageNamed:[(YWDayInfo*)[forecastArray objectAtIndex:0]code]]];
            
            [forecastTableView reloadData];
            
            NSLog(@"%d",recentVisitedPlaces.count);
            [recentVisitTableView reloadData];
            
            [sunRiseLabel setText:currentLocationInfo.sunRise];
            [sunsetLabel setText:currentLocationInfo.sunSet];
            [windSpeed setText:currentLocationInfo.windSpeed];
            [visibility setText:currentLocationInfo.visibilty];
            [humidity setText:currentLocationInfo.humidity];
            
            
        }
        [self startViewRefreshAnimations];
    }
}

-(void)updateDropDownTable:(NSNotification*)notification{
    

    
    if (!dropdownController) {
        dropdownController = [[YWDropDownController alloc] initWithNibName:@"YWDropDownController" bundle:Nil];
        [dropdownController setDelegate:self];
        
        popOverController = [[UIPopoverController alloc] initWithContentViewController:dropdownController];
        [popOverController setPopoverContentSize:dropdownController.view.frame.size];
    }
    [dropdownController setDataArray:notification.object];
    
    [popOverController presentPopoverFromRect:locationSearchTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


-(void)didSelectLocationForWeatherInfo:(NSString*)cityCode withCityName:(NSString*)cityName{
    
    [self getWeatherInforMation:cityCode withCityName:cityName];
    

}

-(void)getWeatherInforMation:(NSString*)cityCode withCityName:(NSString*)cityName{
 
    [popOverController dismissPopoverAnimated:YES];
    [[YWDataController shareDInstance] getWeatherInformationForLocationWithWoeid:cityCode withCityName:cityName];

}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag==ForecastTable)
        return forecastArray.count;
    else{
        if (recentVisitedPlaces.count<=5)
            return recentVisitedPlaces.count;
        else{
            return 5;
        }
    }
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIden = @"ForecastCell";
    static NSString *recentTBIden = @"Cell";
    
    if (tableView.tag==ForecastTable){
        
        YWForecatsCustomCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIden];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"YWForecatsCustomCell" owner:self options:Nil] objectAtIndex:0];
            
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        if (indexPath.row <=forecastArray.count)
                [cell setDayInfo:[forecastArray objectAtIndex:indexPath.row]];
        
        return cell;
        
    }else if (tableView.tag == RecentVisitTable){

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recentTBIden];
        
        if (!cell){
         
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recentTBIden];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
        
        if (indexPath.row <=recentVisitedPlaces.count)
            [cell.textLabel setText:[[recentVisitedPlaces objectAtIndex:indexPath.row] valueForKey:@"Name"]];
        return cell;
    }
    
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==RecentVisitTable) {
        
        
        if (indexPath.row <=recentVisitedPlaces.count){
            [self getWeatherInforMation:[[recentVisitedPlaces objectAtIndex:indexPath.row] valueForKey:@"Code"] withCityName:[[recentVisitedPlaces objectAtIndex:indexPath.row] valueForKey:@"Name"]];
            [locationSearchTextField setText:[[recentVisitedPlaces objectAtIndex:indexPath.row] valueForKey:@"Name"]];
        }
        
    }
}



#pragma mark - View Animations

-(void)startViewRefreshAnimations{
    
    if (viewCollection.count)
        [self rotateViewAroundItslef:[viewCollection objectAtIndex:0]];

}

-(void)rotateViewAroundItslef :(UIView*)viewToRotate{
    
    [UIView transitionWithView:viewToRotate
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations: ^{
                        
                    }
                    completion:^(BOOL finished){
                        ++count;
                        if (count<viewCollection.count){
                            
                            [self rotateViewAroundItslef:[viewCollection objectAtIndex:count]];
                            
                        }else{
                            count=0;
                            return ;
                        }
                        
                    }];
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
    [self.view setUserInteractionEnabled:YES];
    if ([locationSearchTextField isFirstResponder]) {
        
        [locationSearchTextField resignFirstResponder];
    }
}

- (void)startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
        [self.view setUserInteractionEnabled:NO];
    }
}

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         sunImageView.transform = CGAffineTransformRotate(sunImageView.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

@end


//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
//    [locationManager setDelegate:self];
//    [locationManager startUpdatingLocation];


//-(void)getCurrentLocationName{
//
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:locationManager.location
//                   completionHandler:^(NSArray *placemarks, NSError *error) {
//                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
//
//                       if (error){
//                           NSLog(@"Geocode failed with error: %@", error);
//                           return;
//
//                       }
//
//                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
//
//                       locationSearchTextField.text = [NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.locality];
//
//                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
//                       NSLog(@"placemark.country %@",placemark.country);
//                       NSLog(@"placemark.postalCode %@",placemark.postalCode);
//                       NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
//                       NSLog(@"placemark.locality %@",placemark.locality);
//                       NSLog(@"placemark.subLocality %@",placemark.subLocality);
//                       NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
//
//
//                   }];
//
//}
//
//
//- (void)locationManager:(CLLocationManager *)manager
//	didUpdateToLocation:(CLLocation *)newLocation
//		   fromLocation:(CLLocation *)oldLocation{
//
//
//    [self getCurrentLocationName];
//
//}

