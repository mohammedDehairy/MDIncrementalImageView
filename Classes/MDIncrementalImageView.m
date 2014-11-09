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
    imageData = [NSMutableData data];
    imageSource = CGImageSourceCreateIncremental(nil);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:imageUrl] delegate:self startImmediately:NO];
    [connection start];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [imageData appendData:data];
    
    CGImageSourceUpdateData(imageSource, (CFDataRef)imageData, NO);
    
    self.image = [UIImage imageWithCGImage:CGImageSourceCreateImageAtIndex(imageSource, 0, nil)];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    CFRelease(imageSource);
    imageData = nil;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CGImageSourceUpdateData(imageSource, (CFDataRef)imageData, YES);
    
    self.image = [UIImage imageWithCGImage:CGImageSourceCreateImageAtIndex(imageSource, 0, nil)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
