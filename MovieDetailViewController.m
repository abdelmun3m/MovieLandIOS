//
//  MovieDetailViewController.m
//  movies
//
//  Created by IOS OS on 3/1/18.
//  Copyright © 2018 IOS OS. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController (){
    HCSStarRatingView *starRatingView;
    HCSStarRatingView *starFavorite;
    UIColor *greenColorHex;
    UIColor *darkColorHex;
    
}



@end

@implementation MovieDetailViewController{
    Database* instance;
    BOOL isfavorite;
    NSMutableArray* trailersArray;
    NSMutableArray* reviewsArray;
    Boolean expandedOverview;
    int mIndex ;
}
static NSString * const darkHex=@"#081c24";
static NSString * const greenHex=@"#01d277";
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
    mIndex++;
    if(mIndex > [_moviesArray count])
        mIndex=0;
    [self changeMovies];
}
-(void)changeLeft{
    mIndex--;
    if(mIndex < 0)
        mIndex=[_moviesArray count];
    [self changeMovies];
}
-(void)changeMovies{
    //Moving between movies array
    _CurrentMovie = [_moviesArray objectAtIndex:mIndex];
    [self setLayout];

}


- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)viewWillLayoutSubviews{
    [self.view reloadInputViews];
    [_trailerCollection reloadData];
    [_reviewsTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_myScroll setScrollEnabled:YES];
    instance = [Database getInstance];
    mIndex = (int)_currentMovieIndex;
    [self swipeLeft];
    [self swipeRight];
    [self setLayout];
    
}


-(void)setLayout{

    
    NSString* stringImageURL =[MovieAPI GET_MOVIE_IMAGE_PATH_With_Image:_CurrentMovie.poster_path];
    NSURL* imageURL = [[NSURL alloc] initWithString:stringImageURL];
    [_moviePoster sd_setImageWithURL:imageURL];
    [self checkisFavorite:_CurrentMovie.id];
    [_movieTitle setTitle:_CurrentMovie.title];
    [_movieOverview setText:_CurrentMovie.overview];
    _movieOverview.lineBreakMode=NSLineBreakByTruncatingTail;
    _movieOverview.numberOfLines = 3;
    greenColorHex=[self colorFromHexString:greenHex];
    darkColorHex=[self colorFromHexString:darkHex];
    starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(5, -40, 100, 100)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.value = [_CurrentMovie.vote_average floatValue]/2;
    starRatingView.backgroundColor=[UIColor clearColor];
    starRatingView.tintColor = greenColorHex;
    starRatingView.enabled=NO;
    [_imgView addSubview:starRatingView];
    [self getData];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_movieOverview addGestureRecognizer:tapGestureRecognizer];
    _movieOverview.userInteractionEnabled = YES;
}
-(void)labelTapped{
    if(!expandedOverview){
        _movieOverview.lineBreakMode=NSLineBreakByTruncatingTail;
        _movieOverview.numberOfLines = 6;
        expandedOverview=YES;
    }else{
        _movieOverview.numberOfLines = 3;
        expandedOverview=NO;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_reviewsTable setBackgroundColor:darkColorHex];
    expandedOverview=NO;
    starFavorite = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(185, 0, 25, 25)];
    starFavorite.emptyStarImage=[UIImage imageNamed:@"hartWhite2"];
    starFavorite.filledStarImage=[UIImage imageNamed:@"hartRed"];
    starFavorite.maximumValue = 1;
    starFavorite.minimumValue = 0;
    starFavorite.backgroundColor=[UIColor clearColor];
    starFavorite.tintColor = greenColorHex;
    [starFavorite addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];
    if([instance isFavoriteMovieCheckWithID:_CurrentMovie.id]){
        isfavorite = YES;
        starFavorite.value=1;
    }else{
        isfavorite = NO;
        starFavorite.value=0;
    };
    [_imgView addSubview:starFavorite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)favoriteAction{
    if(!isfavorite){
        [instance addFavoriteMovie:_CurrentMovie];
        isfavorite = YES;
        starFavorite.value=1;

    }else{
    
        [instance removeFavoriteMovieWithID:_CurrentMovie.id];
        starFavorite.value=0;
        isfavorite = NO;
    }
    [starFavorite addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];
}


-(void)checkisFavorite:(NSString*)movieID{
    if([instance isFavoriteMovieCheckWithID:movieID]){
    
        isfavorite = YES;
    
    }else{
        isfavorite = NO;
    };
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [reviewsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      UITableViewCell* cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        UITextView* txField=[cell2 viewWithTag:1];
        [txField setText:reviewsArray[indexPath.row]];
    [txField setTextColor:[UIColor whiteColor]];
        return cell2;
}
//-----------trailer collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [trailersArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trailerCell" forIndexPath:indexPath];
    
   UIImageView *img = [cell viewWithTag:1];
    [img setImage:[UIImage imageNamed:@"play64"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *string = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",
                        trailersArray[indexPath.row]];
    NSURL *url = [NSURL URLWithString:string];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:url];
}
- (IBAction)backButton:(id)sender {
    ViewController* main = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    //[main setCurrentMovie: [movieaArray objectAtIndex:indexPath.row]];
    [self presentViewController:main animated:YES completion:nil];
}
-(void)getData{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //get Your category popularmovie | Top rated
    // using MovieAPI class
    NSString* trailersURL = [MovieAPI GET_MOVIE_TRAILERS_REVIEWS__PATH:_CurrentMovie.id];
    NSURL *URL = [NSURL URLWithString:trailersURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            // Handel Error To Featch Data
            //including network is not avilable
            // and no data found
            [self showAlert];
        } else {
            //statr to parse your data
            [self getTrailersArrayfromString:responseObject];
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
-(void)getTrailersArrayfromString:(NSMutableDictionary*) data{
    NSMutableDictionary* trailersobject = [data objectForKey:@"videos"];
    NSMutableArray* trailersList = [trailersobject objectForKey:@"results"];
    trailersobject = [data objectForKey:@"reviews"];
    NSMutableArray* reviewsList = [trailersobject objectForKey:@"results"];
    trailersArray = [NSMutableArray new];
    for (NSMutableDictionary *m in trailersList) {
        NSString* key =[m objectForKey:@"key"];
        trailersArray = [trailersArray arrayByAddingObject:key];
    }
    reviewsArray = [NSMutableArray new];
    //create review object and map data to object and add ata to reviewsArray
    for (NSMutableDictionary *m in reviewsList) {
        NSString* author =[m objectForKey:@"author"];
        NSString* content = [m objectForKey:@"content"];
        NSString* review=[NSString stringWithFormat:@"%@ : %@",author,content];
        reviewsArray = [reviewsArray arrayByAddingObject:review];
    }
    [_trailerCollection setNeedsDisplay];
    [_trailerCollection reloadData];
    [_reviewsTable setNeedsDisplay];
    [_reviewsTable reloadData];
    if([reviewsArray count]>0)
        [_myScroll setContentSize:CGSizeMake(320, 800)];
    else
        [_myScroll setContentSize:CGSizeMake(320, 550)];
}

@end
