//
//  MDIncrementalImageView.m
//  MDIncrementalImageView
//
//  Created by mohamed mohamed El Dehairy on 11/9/14.
//  Copyright (c) 2014 mohamed mohamed El Dehairy. All rights reserved.
//

#import "MDIncrementalImageView.h"

@implementation MDIncrementalImageView
-(void)setImageUrl:(NSURL *)imageUrl
{
    if(_showLoadingIndicatorWhileLoading)
    {
        if(!_loadingIndicator)
        {
            CGFloat width = self.bounds.size.width*0.4;
            
            _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.bounds.size.width-width)/2, (self.bounds.size.height-width)/2, width , width)];
            _loadingIndicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            _loadingIndicator.layer.cornerRadius = width*0.1;
        }
        [self startLoadingIndicator];
    }
    
    
    imageData = [NSMutableData data];
    
    // construct the options Dictionary
    CFStringRef myKeys[1];
    CFTypeRef   myValues[1];
    
    // set caching on
    myKeys[0]   = kCGImageSourceShouldCache;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, (const void**)myKeys, (const void**)myValues, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    // create incremental Image source with the options dictionary
    imageSource = CGImageSourceCreateIncremental(options);
    
    // cleaning up by releasing the options dictionary
    CFRelease(options);
    
    
    
    // start the connection
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:imageUrl] delegate:self startImmediately:NO];
    [connection start];
    
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append new Data
    [imageData appendData:data];
    
    // update image Source
    CGImageSourceUpdateData(imageSource, (CFDataRef)imageData, NO);
    
    // show the partially loaded image
    self.image = [UIImage imageWithCGImage:CGImageSourceCreateImageAtIndex(imageSource, 0, nil)];
    
    
    //inform delegate with the progress ratio
    if([_delegate respondsToSelector:@selector(incrementalImageView:didLoadDataWithRatio:)])
    {
        [_delegate incrementalImageView:self didLoadDataWithRatio:(data.length/expectedLength)];
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    expectedLength = response.expectedContentLength;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // clean up
    CFRelease(imageSource);
    imageData = nil;
    [self stopLoadingIndicator];
    
    // inform delegate that loading failed
    if([_delegate respondsToSelector:@selector(incrementalImageView:didFailWithError:)])
    {
        [_delegate incrementalImageView:self didFailWithError:error];
    }
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //update the image source with a flag that the image loading complete
    CGImageSourceUpdateData(imageSource, (CFDataRef)imageData, YES);
    
    // show the full image
    self.image = [UIImage imageWithCGImage:CGImageSourceCreateImageAtIndex(imageSource, 0, nil)];
    
    // clean up
    CFRelease(imageSource);
    imageData = nil;
    [self stopLoadingIndicator];
    
    //inform delegate that loading finshed successfully
    if([_delegate respondsToSelector:@selector(incrementalImageView:didFinishLoadingWithImage:)])
    {
        [_delegate incrementalImageView:self didFinishLoadingWithImage:self.image];
    }
}

-(void)startLoadingIndicator
{
    if(!_loadingIndicator.superview)
    {
        [self addSubview:_loadingIndicator];
    }
    [_loadingIndicator startAnimating];
}
-(void)stopLoadingIndicator
{
    if(_loadingIndicator.superview)
    {
        [_loadingIndicator removeFromSuperview];
    }
    [_loadingIndicator stopAnimating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
