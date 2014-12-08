//
//  ViewController.m
//  MDIncrementalImageView Demo
//
//  Created by mohamed mohamed El Dehairy on 11/9/14.
//  Copyright (c) 2014 mohamed mohamed El Dehairy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = @[@"http://vpnhotlist.com/wp-content/uploads/2014/03/image.jpg",@"http://www.joomlaworks.net/images/demos/galleries/abstract/7.jpg",@"http://www.last-video.com/wp-content/uploads/2013/11/superbe-image-de-poissons-sous-l-eau.jpg",@"http://mintywhite.com/wp-content/uploads/2012/10/fond-ecran-wallpaper-image-arriere-plan-hd-29-HD.jpg",@"http://www.islamic-literatures.com/wp-content/uploads/2013/06/grande-image3.png",@"http://www.jssor.com/img/home/03.jpg",@"http://www.britishlegion.org.uk/ImageGen.ashx?width=800&image=/media/2019101/id23055-normandy-66th_-schools-visit-poppy-choice_-pupils-from-london-city-academy.jpg",@"http://www.wonderplugin.com/wp-content/plugins/wonderplugin-lightbox/images/demo-image1.jpg",@"http://youthvoices.net/sites/default/files/image/25902/jun/images-7.jpg",@"http://farm9.staticflickr.com/8378/8559402848_9fcd90d20b_b.jpg",@"http://www.orange.mg/sites/default/files/image-petite-annonce/image2.jpg",@"http://wwws3.eea.europa.eu/highlights/populations-of-grassland-butterflies-decline/european-grassland-butterfly-indicator-pictures/marsh-fritillary-euphydryas-aurinia/image_large",@"http://news.bbcimg.co.uk/media/images/71832000/jpg/_71832498_71825880.jpg"];
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:tableV];
    tableV.delegate  = self;
    tableV.dataSource = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if(![cell viewWithTag:111])
    {
        MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake(25, 5, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 111;
        [cell addSubview:imageView];
    }
    
    MDIncrementalImageView *imageView = (MDIncrementalImageView*)[cell viewWithTag:111];
    [imageView setImageUrl:[NSURL URLWithString:[dataSource objectAtIndex:indexPath.row]] showLoadingIndicatorWhileLoading:YES delegate:nil];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
