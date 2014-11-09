//
//  MDIncrementalImageView.h
//  MDIncrementalImageView
//
//  Created by mohamed mohamed El Dehairy on 11/9/14.
//  Copyright (c) 2014 mohamed mohamed El Dehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface MDIncrementalImageView : UIImageView<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *imageData ;
    CGImageSourceRef imageSource;
    
    UIActivityIndicatorView *loadingIndicator;
}
@property(nonatomic)BOOL showLoadingIndicatorWhileLoading;
-(void)setImageUrl:(NSURL *)imageUrl;
@end
