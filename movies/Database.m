//
//  Database.m
//  Design
//
//  Created by JETS on 2/12/18.
//  Copyright (c) 2018 JETS. All rights reserved.
//

#import "Database.h"

@implementation Database
-(id)init
{
    self = [super init];
    if (self) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths =
        NSSearchPathForDirectoriesInDomains(
                                            
                                                       NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        // Build the path to the database file
        _databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"FavoriteMovie1.1.db"]];
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS favorite_movie (ID TEXT PRIMARY KEY, TITLE TEXT, poster_path TEXT,overview TEXT, release_data TEXT,vote_average TEXT)";
        
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
            }
            sqlite3_close(_contactDB);
        } else {
        }
    }
    return self;
}


-(BOOL)addFavoriteMovie:(Movie*)movie{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    BOOL inserted= NO;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO favorite_movie (id, title, poster_path,overview,release_data,vote_average) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                                    movie.id,movie.title,movie.poster_path,movie.overview,movie.release_date,movie.vote_average];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
        {
            inserted = YES;
        } else {
            inserted = NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    
    return inserted;
}
-(BOOL)isFavoriteMovieCheckWithID:(NSString*) movieId{
    BOOL existed = NO;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT id FROM favorite_movie WHERE id=\"%@\"",
                              movieId];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1,
                               &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
            
                existed = YES;
                //@"Match found";
            } else {
                existed = NO;
               //@"Match not found";
            }
            sqlite3_finalize(statement);
        }	
        sqlite3_close(_contactDB);
    }
    return existed;
}
-(BOOL)removeFavoriteMovieWithID:(NSString*)movieId{
    
    BOOL removed = NO;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM favorite_movie WHERE id=\"%@\"",
                              movieId];
            
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                removed = YES;
            }else{
                removed = NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    
    return removed;
}
-(NSMutableArray *)getAllFAvoriteMovies{
    NSMutableArray *MovieList = [[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM favorite_movie"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {

         while(sqlite3_step(statement) == SQLITE_ROW){
             Movie *movie=[Movie new];

             NSString *id = [[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 0)];
             NSString *title = [[NSString alloc]
                                initWithUTF8String:(const char *)
                                sqlite3_column_text(statement, 1)];
             NSString *poster_path = [[NSString alloc]
                              initWithUTF8String:(const char *)
                              sqlite3_column_text(statement, 2)];
             NSString *overview = [[NSString alloc]
                              initWithUTF8String:(const char *)
                              sqlite3_column_text(statement, 3)];
             NSString *release_date = [[NSString alloc]
                              initWithUTF8String:(const char *)
                              sqlite3_column_text(statement, 4)];
             NSString *vote_average = [[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 5)];
             
             movie.title = title;
             movie.poster_path = poster_path;
             movie.overview = overview;
             movie.release_date = release_date;
             movie.vote_average = vote_average;
             movie.id = id;
             
             [MovieList addObject:movie];
    
          }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    return MovieList;
}
+(Database *)getInstance{
    static Database * sharedInstance=nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        sharedInstance=[[Database alloc] init];
    });
    return sharedInstance;
}

@end
