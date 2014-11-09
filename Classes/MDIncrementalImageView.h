//
//  MDIncrementalImageView.h
//  MDIncrementalImageView
//
//  Created by mohamed mohamed El Dehairy on 11/9/14.
//  Copyright (c) 2014 mohamed mohamed El Dehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ImageIO/ImageIO.h>

@class MDIncrementalImageView;

@protocol MDIncrementalImageViewDelegate <NSObject>

-(void)incrementalImageView:(MDIncrementalImageView*)imageView didLoadDataWithRatio:(CGFloat)ratio;
-(void)incrementalImageView:(MDIncrementalImageView*)imageView didFinishLoadingWithImage:(UIImage*)image;
-(void)incrementalImageView:(MDIncrementalImageView*)imageView didFailWithError:(NSError*)error;

@end

@interface MDIncrementalImageView : UIImageView<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *imageData ;
    long long expectedLength;
    NSURLConnection *currentConnection;
    
}
@property(nonatomic,readonly)UIActivityIndicatorView *loadingIndicator;
@property(nonatomic)BOOL showLoadingIndicatorWhileLoading;
@property(nonatomic,weak)id<MDIncrementalImageViewDelegate> delegate;

-(void)setImageUrl:(NSURL *)imageUrl;
@end
