//
//  CoreDataManager.h
//  Diary
//
//  Created by Mac on 08.08.15.
//  Copyright (c) 2015 CEIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Note.h"


@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController* notesFetchController;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)addNewNoteWithTitle:(NSString*)title
                       text:(NSString*)text;

- (void)removeNote:(NSManagedObject*)note;

@end
