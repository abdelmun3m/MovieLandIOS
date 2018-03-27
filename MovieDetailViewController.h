//
//  MovieDetailViewController.h
//  movies
//
//  Created by IOS OS on 3/1/18.
//  Copyright © 2018 IOS OS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MovieAPI.h"
#import "Movie.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Database.h"
#import "ViewController.h"
#import "HCSStarRatingView.h"

@interface MovieDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *imgView;
@property int *currentMovieIndex;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;

- (IBAction)backButton:(id)sender;
@property Movie* CurrentMovie;
@property NSMutableArray* moviesArray;
@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;
//@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UICollectionView *trailerCollection;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTable;
@property (weak, nonatomic) IBOutlet UILabel *movieOverview;

@property (weak, nonatomic) IBOutlet UINavigationItem *movieTitle;
@end
