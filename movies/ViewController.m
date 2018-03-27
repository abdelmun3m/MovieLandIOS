//
//  ViewController.m
//  movies
//
//  Created by IOS OS on 3/1/18.
//  Copyright © 2018 IOS OS. All rights reserved.
//

#import "ViewController.h"
#import "MovieAPI.h"
#import "Movie.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Database.h"

@interface ViewController (){
    NSMutableArray* movieaArray;
    NSInteger* CurrentCategory;
    UIColor *darkColorHex;
    UIColor *greenColorHex;
    int tabs;
    AFURLSessionManager *manager;
}

@end

@implementation ViewController

static NSString * const greenHex=@"#01d277";
static NSString * const darkHex=@"#081c24";
static NSString * const reuseIdentifier = @"Cell";
static NSInteger* const POPULAR_MOVIES_ID = 0;
static NSInteger* const TOP_RATED_MOVIES_ID = 1;
static NSInteger* const FAVORITE_MOVIES_ID = 2;

-(void)swipeRight{
    UISwipeGestureRecognizer *rec=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeRight)];
    rec.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:rec];
}
-(void)swipeLeft{
    UISwipeGestureRecognizer *rec2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeLeft)];
    rec2.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rec2];
}



-(void)changeRight{

    tabs++;
    if(tabs>2)
        tabs=0;
    [self changeTabs];
}


-(void)changeLeft{
    tabs--;
    if(tabs<0)
        tabs=2;
    [self changeTabs];
}

-(void)changeTabs{
    switch (tabs) {
        case 0:
            [self showPopularMovies:nil];
            break;
        case 1:
            [self showTopRated:nil];
            break;
        case 2:
            [self displayFavoriteMovie];
            break;
        
        default:
            [self getDataWithCategory:POPULAR_MOVIES_ID];
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    tabs=0;
    greenColorHex=[self colorFromHexString:greenHex];
    darkColorHex=[self colorFromHexString:darkHex];
    [self showPopularMovies:nil];

}


-(void)viewWillLayoutSubviews{
    [self.view setNeedsDisplay];
    [_collectionView reloadData];
    [self swipeRight];
    [self swipeLeft];
	
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width/2)-10, 250);
}
-(void)viewWillAppear:(BOOL)animated{
    //    self.collectionView.contentInset = UIEdgeInsetsMake(75,0,0,0);
    //[self.navigationController.navigationBar setHidden:YES];
   
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [movieaArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    UIImageView *moviePoster=[cell viewWithTag:100];
    Movie *m=[movieaArray objectAtIndex:indexPath.row];
    NSString* stringImageURL =[MovieAPI GET_MOVIE_IMAGE_PATH_With_Image:m.poster_path];
    NSURL* imageURL = [[NSURL alloc] initWithString:stringImageURL];
    [moviePoster sd_setImageWithURL: imageURL];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //on Movie Clicked
    MovieDetailViewController* detail = [self.storyboard instantiateViewControllerWithIdentifier:@"movieDetails"];
    [detail setCurrentMovie: [movieaArray objectAtIndex:indexPath.row]];
    int x = (int) indexPath.row;
    [detail setCurrentMovieIndex:x];
    [detail setMoviesArray:movieaArray];
    [self presentViewController:detail animated:YES completion:nil];
    
}

-(void)getDataWithCategory:(NSInteger*) category{
    CurrentCategory = category;
    
    
    
    NSString* categoryURL;
    if(CurrentCategory == POPULAR_MOVIES_ID){
        categoryURL =[MovieAPI GET_POPULAR_MOVIES_URL];
    }else if(CurrentCategory == TOP_RATED_MOVIES_ID){
        categoryURL =[MovieAPI GET_TOP_RATED_MOVIES_URL];
    }
    NSURL *URL = [NSURL URLWithString:categoryURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
                [self showAlert];
        } else {
            
            
            if(responseObject == nil){
                [self showAlert];
            }else{
                [self getMoviesArrayfromString:responseObject];
            }
            
            
        }
    }];
    [dataTask resume];
    
}
-(void) showAlert{

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Ooops"
                                                  message:@"No Network Connection Available"
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"ok", nil];
    [alert show];
}
-(void)getMoviesArrayfromString:(NSMutableDictionary*) data{

    
    NSMutableArray* moviesList = [data objectForKey:@"results"];
    
    
     movieaArray = [NSMutableArray new];
    for (NSMutableDictionary *m in moviesList) {
        Movie *movie =
        [[Movie alloc] initWithDictionary:m error:nil];
       movieaArray = [movieaArray arrayByAddingObject:movie];
    }
    MovieDetailViewController* detail = [self.storyboard instantiateViewControllerWithIdentifier:@"movieDetails"];
    [detail setMoviesArray:movieaArray];
    [_collectionView setNeedsDisplay];
    [_collectionView reloadData];
}

- (IBAction)showFavorit:(id)sender {
    [self displayFavoriteMovie];
}
-(void) displayFavoriteMovie{
    tabs = FAVORITE_MOVIES_ID;
    Database* instance = [Database getInstance];
    movieaArray=instance.getAllFAvoriteMovies;
    [_collectionView setNeedsDisplay];
    [_collectionView reloadData];
    [self setActiveButton];
}

- (IBAction)showPopularMovies:(id)sender{
    tabs = POPULAR_MOVIES_ID;
    [self getDataWithCategory:POPULAR_MOVIES_ID];
    [self setActiveButton];
    
}
-(void)showTopRated:(id)sender{
    
    tabs = TOP_RATED_MOVIES_ID;
    [self getDataWithCategory:TOP_RATED_MOVIES_ID];
    [self setActiveButton];
  }

-(void) setActiveButton{
    [_btntopRted setTintColor:darkColorHex];
    [_favoriteButton setTintColor:darkColorHex];
    [_btnPopular setTintColor:darkColorHex];
    switch (tabs) {
        case 0:
            [_btnPopular setTintColor:greenColorHex];
            break;
        case 1:
            [_btntopRted setTintColor:greenColorHex];
            break;
        case 2:
            [_favoriteButton setTintColor:greenColorHex];
            break;
            
        default:
            [_btnPopular setTintColor:greenColorHex];
            break;
    }

}


@end
