//
//  MDIncrementalImageView.m
//  MDIncrementalImageView
//
//  Created by mohamed mohamed El Dehairy on 11/9/14.
//  Copyright (c) 2014 mohamed mohamed El Dehairy. All rights reserved.
//

#import "MDIncrementalImageView.h"

@interface MDIncrementalImageView () <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *imageData;
@property(nonatomic) long long expectedLength;
@property(nonatomic,strong) NSURLConnection *currentConnection;
@property(nonatomic, strong)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,weak)id<MDIncrementalImageViewDelegate> delegate;

@end

@implementation MDIncrementalImageView

-(void)setImageUrl:(NSURL *)imageUrl showLoadingIndicatorWhileLoading:(BOOL)indicator delegate:(id<MDIncrementalImageViewDelegate>)delegate
{
	[self cleanUp];
	
	self.delegate = delegate;
	
    //reset current image
    self.image = nil;
    
    if(indicator)
    {
        //show the loading indicator
        
        if(!self.loadingIndicator)
        {
            CGFloat width = self.bounds.size.width*0.4;
            
            self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.bounds.size.width-width)/2, (self.bounds.size.height-width)/2, width , width)];
            self.loadingIndicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            self.loadingIndicator.layer.cornerRadius = width*0.1;
        }
        [self addSubview:self.loadingIndicator];
		[self.loadingIndicator startAnimating];
    }
    
    // initialize the placeholder data
    self.imageData = [NSMutableData data];
    
    
    // start the connection
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    self.currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append new Data
    [self.imageData appendData:data];
    
    // show the partially loaded image
    self.image = [UIImage imageWithData:self.imageData];
    
    
    //inform delegate with the progress ratio
    if([self.delegate respondsToSelector:@selector(incrementalImageView:didLoadDataWithRatio:)])
    {
        [self.delegate incrementalImageView:self didLoadDataWithRatio:(data.length/self.expectedLength)];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.expectedLength = response.expectedContentLength;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform delegate that loading failed
    if([self.delegate respondsToSelector:@selector(incrementalImageView:didFailWithError:)])
    {
        [self.delegate incrementalImageView:self didFailWithError:error];
    }

	[self cleanUp];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // show the full image
    self.image = [UIImage imageWithData:self.imageData];
    
    //inform delegate that loading finshed successfully
    if([self.delegate respondsToSelector:@selector(incrementalImageView:didFinishLoadingWithImage:)])
    {
        [self.delegate incrementalImageView:self didFinishLoadingWithImage:self.image];
    }
	
	[self cleanUp];
}

-(void)cleanUp
{
	self.delegate = nil;
	[self.currentConnection cancel];
	self.currentConnection = nil;
    self.imageData = nil;
	[self.loadingIndicator removeFromSuperview];
	[self.loadingIndicator stopAnimating];
	self.loadingIndicator = nil;
}

@end
