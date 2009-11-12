//
//  BlogListThumbsDataSource.m
//  MobilBlogg
//
//  Created by Tobias Rundström on 2009-11-12.
//  Copyright 2009 Purple Scout. All rights reserved.
//

#import "BlogListThumbsDataSource.h"
#import "MBPhoto.h"

@implementation BlogListThumbsDataSource

@synthesize title = albumTitle;

- (id)initWithModel:(BlogListModel *)theModel
{
    if ((self = [super init])) {
        albumTitle = @"Photos";
        model = [theModel retain];
    }
    return self;
}

- (id<TTModel>)underlyingModel
{
    return model;
}

// -----------------------------------------------------------------------
#pragma mark Forwarding

// Forward unknown messages to the underlying TTModel object.
- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([model respondsToSelector:[invocation selector]])
        [invocation invokeWithTarget:model];
    else
        [super forwardInvocation:invocation];
}

- (BOOL)respondsToSelector:(SEL)selector
{
    if ([super respondsToSelector:selector])
        return YES;
    else
        return [model respondsToSelector:selector];
}

- (BOOL)conformsToProtocol:(Protocol *)protocol
{
    if ([super conformsToProtocol:protocol])
        return YES;
    else
        return [model conformsToProtocol:protocol];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature)
        signature = [model methodSignatureForSelector:selector];
    return signature;
}

// -----------------------------------------------------------------------
#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos 
{
    return [model totalResultsAvailableOnServer];
}

- (NSInteger)maxPhotoIndex
{
    return [[model results] count] - 1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index 
{
    if (index < 0 || index > [self maxPhotoIndex])
        return nil;
    
    // Construct an object (PhotoItem) that is suitable for Three20's
    // photo browsing system from the domain object (SearchResult)
    // at the specified index in the TTModel.
    MBPhoto	*photo = [[model results] objectAtIndex:index];
    photo.index = index;
    photo.photoSource = self;
    return photo;
}

// -----------------------------------------------------------------------
#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ delegates: %@", [super description], [self delegates]];
}

- (void)dealloc
{
    [model release];
    [albumTitle release];
    [super dealloc];
}

@end
