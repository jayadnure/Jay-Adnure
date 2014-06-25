//
//  DataOperationNC.h
//  NSOperationSample
//
//  Created by Adnure, Jay Kolhapur on 6/18/14.
//  Copyright (c) 2014 Adnure, Jay Kolhapur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataOperationNC : NSOperation{
    
    BOOL executing;
    BOOL finished;

}

-(id)initWithReuestString: (NSString*)_urlString;

@end




/*Avoid these things in this class*/
/*
 
 Avoid Per-Thread Storage
 
 Although most operations execute on a thread, in the case of nonconcurrent operations, that thread is usually provided by an operation queue. If an operation queue provides a thread for you, you should consider that thread to be owned by the queue and not to be touched by your operation. Specifically, you should never associate any data with a thread that you do not create yourself or manage. The threads managed by an operation queue come and go depending on the needs of the system and your application. Therefore, passing data between operations using per-thread storage is unreliable and likely to fail.
 
 In the case of operation objects, there should be no reason for you to use per-thread storage in any case. When you initialize an operation object, you should provide the object with everything it needs to do its job. Therefore, the operation object itself provides the contextual storage you need. All incoming and outgoing data should be stored there until it can be integrated back into your application or is no longer required.
 
 Keep References to Your Operation Object As Needed
 
 Just because operation objects run asynchronously, you should not assume that you can create them and forget about them. They are still just objects and it is up to you to manage any references to them that your code needs. This is especially important if you need to retrieve result data from an operation after it is finished.
 
 The reason you should always keep your own references to operations is that you may not get the chance to ask a queue for the object later. Queues make every effort to dispatch and execute operations as quickly as possible. In many cases, queues start executing operations almost immediately after they are added. By the time your own code goes back to the queue to get a reference to the operation, that operation could already be finished and removed from the queue.
 

 Performance Overview.
 
 You should also avoid adding large numbers of operations to a queue all at once, or avoid continuously adding operation objects to a queue faster than they can be processed. Rather than flood a queue with operation objects, create those objects in batches. As one batch finishes executing, use a completion block to tell your application to create a new batch. When you have a lot of work to do, you want to keep the queues filled with enough operations so that the computer stays busy, but you do not want to create so many operations at once that your application runs out of memory.
 
 Suspending and Resuming Queues
 If you want to issue a temporary halt to the execution of operations, you can suspend the corresponding operation queue using the setSuspended: method. Suspending a queue does not cause already executing operations to pause in the middle of their tasks. It simply prevents new operations from being scheduled for execution. You might suspend a queue in response to a user request to pause any ongoing work, because the expectation is that the user might eventually want to resume that work.
 
 */