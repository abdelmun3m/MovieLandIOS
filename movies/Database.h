//
//  Database.h
//  Design
//
//  Created by JETS on 2/12/18.
//  Copyright (c) 2018 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Movie.h"
@interface Database : NSObject

@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

+(Database*)getInstance;
-(NSMutableArray *)getAllFAvoriteMovies;
-(BOOL)removeFavoriteMovieWithID:(NSString*)movieId;
-(BOOL)isFavoriteMovieCheckWithID:(NSString*) movieId;
-(BOOL)addFavoriteMovie:(Movie*)movie;
@end
