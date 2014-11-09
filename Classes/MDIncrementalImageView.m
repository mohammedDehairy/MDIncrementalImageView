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
    // discard the previous connection
    if(currentConnection)
    {
        [currentConnection cancel];
    }
    
    //reset current image
    self.image = nil;
    
    
    if(_showLoadingIndicatorWhileLoading)
    {
        //show the loading indicator
        
        if(!_loadingIndicator)
        {
            CGFloat width = self.bounds.size.width*0.4;
            
            _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.bounds.size.width-width)/2, (self.bounds.size.height-width)/2, width , width)];
            _loadingIndicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            _loadingIndicator.layer.cornerRadius = width*0.1;
        }
        [self startLoadingIndicator];
    }
    
    // initialize the placeholder data
    imageData = [NSMutableData data];
    
    
    // start the connection
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //if the image view is reused in a table view for example to load another image  previous image is discarded
    if(connection != currentConnection)
    {
        [connection cancel];
        [self cleanUp];
        return;
    }
    
    // append new Data
    [imageData appendData:data];
    
    // show the partially loaded image
    self.image = [UIImage imageWithData:imageData];
    
    
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
    [self cleanUp];
    
    // inform delegate that loading failed
    if([_delegate respondsToSelector:@selector(incrementalImageView:didFailWithError:)])
    {
        [_delegate incrementalImageView:self didFailWithError:error];
    }
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    // show the full image
    self.image = [UIImage imageWithData:imageData];
    
    // clean up
    [self cleanUp];
    
    //inform delegate that loading finshed successfully
    if([_delegate respondsToSelector:@selector(incrementalImageView:didFinishLoadingWithImage:)])
    {
        [_delegate incrementalImageView:self didFinishLoadingWithImage:self.image];
    }
}
-(void)cleanUp
{
    // clean up
    imageData = nil;
    [self stopLoadingIndicator];
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
