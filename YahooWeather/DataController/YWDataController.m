//
//  YWDataController.m
//  YahooWeather
//
//  Created by Adnure, Jay Kolhapur on 6/19/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import "YWDataController.h"
#import "DataOperationNC.h"
#import "XMLReader.h"

static YWDataController *ywDataController;


#define  WOEID_FINDER_URL @"https://query.yahooapis.com/v1/public/yql?q=select * from geo.placefinder where text="
#define WeatherInfo_URL @"http://weather.yahooapis.com/forecastrss?w="


@implementation YWDataController

+(YWDataController*)shareDInstance{
    
    static dispatch_once_t pred;

    dispatch_once(&pred, ^{
        
        ywDataController = [[YWDataController alloc] init];
        
    });
 
    return ywDataController;

}

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadWeatherInfo:) name:@"Download_Completed" object:nil];
        resourcePathForRVP = [self getPathToDirectoryForAsset:@"YWRecentlyVisitedPlist" withExtention:@"plist"];
        
        recentVisitedPlaces = [NSMutableArray arrayWithContentsOfFile:resourcePathForRVP];
    }
    
    return self;
}

-(void)getLocationInformation :(NSString*)locationInformation{
    
    NSMutableString *baseUrlString = [NSMutableString string];
    
    [baseUrlString appendString:WOEID_FINDER_URL];
    
    [baseUrlString appendString:@"%22"];
    [baseUrlString appendString:locationInformation];
    [baseUrlString appendString:@"%22"];
    
    dataOperation = [[DataOperationNC alloc] initWithReuestString:[baseUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    [[NSOperationQueue mainQueue] addOperation:dataOperation];
    
    baseUrlString = nil;
}

-(void)getWeatherInformationForLocationWithWoeid: (NSString*)woeid withCityName:(NSString*)cityName{
    
    NSMutableString *baseUrlString = [NSMutableString string];
    
    [baseUrlString appendString:WeatherInfo_URL];
    
    [baseUrlString appendString:woeid];
    [baseUrlString appendString:@"&u=c"];
    
    dataOperation = [[DataOperationNC alloc] initWithReuestString:[baseUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    [[NSOperationQueue mainQueue] addOperation:dataOperation];
    
    baseUrlString = nil;
    
    [self addLocationInformationToPlistEWithName:cityName withCode:woeid];
    
    
}


-(void)downloadWeatherInfo:(NSNotification*)notification{
    
    if (notification.object!=nil){
        
        if (!currentLocationInfo){
            
            NSArray *locationsArray = [[[notification.object valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"Result"];
            
            
            if ([[[[notification.object valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"Result"] isKindOfClass:[NSDictionary class]]) {
                
                NSString *woeid = [self getWoeidFromInfoDict:[notification object]];
                NSString *cityName = [self getNameFromInfoDict:[notification object]  withKey:@"city"];
                if (!cityName) {
                    
                    //Take Country Name
                    cityName = [self getNameFromInfoDict:[notification object]  withKey:@"country"];
                }
                [self getWeatherInformationForLocationWithWoeid:woeid withCityName:cityName];
                
                currentLocationInfo = [[YWLocationInfo alloc] init];
                
            }else if ([[[[notification.object valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"Result"] isKindOfClass:[NSArray class]]){
                
                currentLocationInfo = [[YWLocationInfo alloc] init];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Update_Dropdown" object:locationsArray];
                
                
                
            }
            
        }else{
            
            [currentLocationInfo populateDetailsOfWeather:notification.object];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Update_Details" object:currentLocationInfo];
        }
        
    }
    
}

-(NSString*)getWoeidFromInfoDict: (NSDictionary*)infoDict{
    
    if ([[[[[[infoDict valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"Result"] valueForKey:@"woeid"] valueForKey:@"sample_text"] isKindOfClass:[NSString class]]) {
        
      
        
        return [[[[[infoDict valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"Result"] valueForKey:@"woeid"] valueForKey:@"sample_text"];
    }
    
    return Nil;
}

-(NSString*)getNameFromInfoDict: (NSDictionary*)infoDict withKey:(NSString*)key{
    
    if ([[[[[[infoDict valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"Result"] valueForKey:key] valueForKey:@"sample_text"] isKindOfClass:[NSString class]]) {

        return [[[[[infoDict valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"Result"] valueForKey:key] valueForKey:@"sample_text"];
    }
    
    return Nil;
}


-(void)resetDetails{
    
    currentLocationInfo = nil;
}


#pragma mark - Data Operations

-(NSArray*)getRecentlyVistedPlaces{
    
    return recentVisitedPlaces;
}

#pragma mark - Add recent Places to plist

-(void)addLocationInformationToPlistEWithName :(NSString*)name withCode:(NSString*)code{
    
     NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:name,@"Name",code,@"Code", nil];
    if (![self isLocationAlreadyPresentInTheArray:infoDict]){
        
        /*Just maintain first 5 places Visited*/
        
        if (recentVisitedPlaces.count >4) {
            
            [recentVisitedPlaces insertObject:infoDict atIndex:0];
        }else{
            
            [recentVisitedPlaces addObject:infoDict];

        }
        
       
        [recentVisitedPlaces writeToFile:resourcePathForRVP atomically:YES];
    }
}

-(NSString*)getPathToDirectoryForAsset:(NSString*)assetName withExtention:(NSString*)extention{
    
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",assetName,extention]]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:assetName ofType:extention]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    
    return path;
}

-(BOOL)isLocationAlreadyPresentInTheArray:(NSDictionary*)infoDict{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.%K contains[c] %@", @"Code",[infoDict valueForKey:@"Code"]];
    
    
    NSArray *result = [recentVisitedPlaces filteredArrayUsingPredicate:pred];
    
    if (result.count) {
        
        return YES;
    
    }
 
    result = nil;
    pred = nil;
    
    return NO;
}

@end
