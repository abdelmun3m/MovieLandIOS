//
//  ViewController.h
//  movies
//
//  Created by IOS OS on 3/1/18.
//  Copyright © 2018 IOS OS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MovieDetailViewController.h"
@interface ViewController : UIViewController




@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *btntopRted;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnPopular;


- (IBAction)showPopularMovies:(id)sender;

- (IBAction)showFavorit:(id)sender;

- (IBAction)showTopRated:(id)sender;

@end

