//
//  MovieAPI.h
//  lab2
//
//  Created by Mohamed Ashraf on 2/28/18.
//  Copyright © 2018 Mohamed Ashraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieAPI : NSObject
+(NSString*) GET_TOP_RATED_MOVIES_URL;
+(NSString*) GET_POPULAR_MOVIES_URL;
+(NSString*) GET_MOVIE_IMAGE_PATH_With_Image:(NSString*)image;
+(NSString*) GET_MOVIE_TRAILERS_REVIEWS__PATH:(NSString*)key;

@end
