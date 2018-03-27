//
//  MovieAPI.m
//  lab2
//
//  Created by Mohamed Ashraf on 2/28/18.
//  Copyright © 2018 Mohamed Ashraf. All rights reserved.
//

#import "MovieAPI.h"

@implementation MovieAPI



const NSString* API_KEY = @"a26b061467611fb1fc2dabf560a402c6";
const NSString* MOVIE_API_BASE_UTL = @"https://api.themoviedb.org/3/movie/";
const NSString* QUERY = @"?";
const NSString* QUERY_KEY = @"api_key=";
const NSString* QUERY_LANG_AND_PAGES = @"&language=en-US&page=1";
const NSString* IMAGE_PATH = @"https://image.tmdb.org/t/p/w342/";




+(NSString*) GET_POPULAR_MOVIES_URL{

    NSString* popularDir = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/popular?api_key=%@&language=en-US&page=1",API_KEY];
    return popularDir;
}

+(NSString*) GET_TOP_RATED_MOVIES_URL{
    NSString* popularDir = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/top_rated?api_key=%@&language=en-US&page=1",API_KEY];
    return popularDir;
}

+(NSString*) GET_MOVIE_IMAGE_PATH_With_Image:(NSString*)image {
    return [IMAGE_PATH stringByAppendingString:image];
}





+(NSString*) GET_MOVIE_TRAILERS_REVIEWS__PATH:(NSString*)movieId{
    
    
     NSString* trailersURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@&append_to_response=videos,reviews",movieId,API_KEY];
    
    return trailersURL;
}





@end
