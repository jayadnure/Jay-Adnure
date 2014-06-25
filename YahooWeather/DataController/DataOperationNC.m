//
//  DataOperationNC.m
//  NSOperationSample
//
//  Created by Adnure, Jay Kolhapur on 6/18/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import "DataOperationNC.h"

#import "XMLReader.h"

@interface DataOperationNC ()<NSURLConnectionDelegate>{
    
    
    NSMutableData *data;
    NSMutableURLRequest *request;
    NSURLConnection *connection;
    NSString *urlString;
}

@end

@implementation DataOperationNC


-(id)initWithReuestString: (NSString*)_urlString{
    
    self = [super init];
    
    if (self) {
        
        executing = NO;
        finished = NO;
        urlString = _urlString;
     

    }
    
    return self;
}

-(void)main{
    
    @try {
        
        // Do the main work of the operation here.
      
        [self startDownloadOperation];
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[exception description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];

    }
    @finally {
        
    }
}

- (void)completeOperation {
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    

    
    data = Nil;
    connection =Nil;
    request = Nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)complete{
    
    //NSLog(@"Complete");
}

-(void)start{
    
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    
  //  [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    [self startDownloadOperation];
   
    
    executing = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    
    
}

// This should return Yes to show its a concurrent operation
- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}


/*Download Delegate*/

//http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text="Kolhapur"
//http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text=%22Kolhapur%22

-(void)startDownloadOperation{
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (url){
        
        request = [[NSMutableURLRequest alloc] initWithURL:url];
        connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
    if (connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [connection start];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_STARTED" object:nil];
    }
    
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (!data)
        data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data_{

    //   NSLog(@"didReceiveData");
   
    [data appendData:data_];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *testXMLString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSDictionary *xmlDictionary;
    if (testXMLString.length){
        
        xmlDictionary = [XMLReader dictionaryForXMLString:testXMLString error:Nil];
        


    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Download_Completed" object:xmlDictionary];
    [self completeOperation];

    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Download_Completed" object:nil];
    [self completeOperation];
}

@end
