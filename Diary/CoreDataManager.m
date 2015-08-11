//
//  CoreDataManager.m
//  Diary
//
//  Created by Mac on 08.08.15.
//  Copyright (c) 2015 CEIT. All rights reserved.
//

#import "CoreDataManager.h"

#define lNotesEntity  @"Note"
#define lNotesSortingKey @"timeStamp"

@implementation CoreDataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize notesFetchController = _notesFetchController;

- (void)addNewNoteWithTitle:(NSString*)title
                       text:(NSString*)text
{
    NSManagedObject* theNote = [NSEntityDescription insertNewObjectForEntityForName:lNotesEntity inManagedObjectContext:[self managedObjectContext]];
    
    [theNote setValue:title forKey:@"title"];
    [theNote setValue:text forKey:@"text"];
    [theNote setValue:[NSDate date] forKey:@"timeStamp"];
    [self saveContext];
}

- (void)removeNote:(NSManagedObject*)note
{
    [[self managedObjectContext] deleteObject:note];
    [self saveContext];
}

- (NSFetchedResultsController*)notesFetchController
{
    if (_notesFetchController) {
        return _notesFetchController;
    }
    
    NSEntityDescription* notesEntity = [NSEntityDescription entityForName:lNotesEntity inManagedObjectContext:[self managedObjectContext]];
    
    NSFetchRequest* notesRequest = [[NSFetchRequest alloc]init];
    [notesRequest setEntity:notesEntity];
    
    NSSortDescriptor* dateSortDescriptor = [[NSSortDescriptor alloc]initWithKey:lNotesSortingKey ascending:NO];
    [notesRequest setSortDescriptors:@[dateSortDescriptor]];
    
    _notesFetchController = [[NSFetchedResultsController alloc]initWithFetchRequest:notesRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    NSError* error = nil;
    if(![_notesFetchController performFetch:&error]){
        NSLog(@"%@",[error localizedDescription]);
    }
    
    return _notesFetchController;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "RAJ.Diary" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Diary" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Diary.sqlite"];
    
    NSError *error = nil;
    
    NSDictionary* migrationOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:migrationOptions error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
