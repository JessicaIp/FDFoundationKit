#import "NSObject+PerformBlock.h"


#pragma mark Class Definition

@implementation NSObject (PerformBlock)


#pragma mark - Public Methods

- (void)performBlock: (dispatch_block_t)block 
	afterDelay: (NSTimeInterval)delay
{
	[self performSelector: @selector(_callBlock:) 
		withObject: block 
		afterDelay: delay];
}

- (void)performBlockOnMainThread: (dispatch_block_t)block 
	waitUntilDone: (BOOL)waitUntilDone
{
	if (waitUntilDone == YES)
	{
		if ([NSThread isMainThread] == NO)
		{
			dispatch_sync(
				dispatch_get_main_queue(), 
				block);
		}
		else
		{
			block();
		}
	}
	else
	{
		dispatch_async(
			dispatch_get_main_queue(), 
			block);
	}
}

- (void)performBlockOnMainThread: (dispatch_block_t)block
{
	[self performBlockOnMainThread: block 
		waitUntilDone: NO];
}

- (void)performBlockInBackground: (dispatch_block_t)block
{
	dispatch_queue_t globalQueue = dispatch_get_global_queue(
		DISPATCH_QUEUE_PRIORITY_BACKGROUND, 
		0);
	
	dispatch_async(
		globalQueue, 
		block);
}


#pragma mark - Private Methods

- (void)_callBlock: (dispatch_block_t)block
{
	block();
}


@end