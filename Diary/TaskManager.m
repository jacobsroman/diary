//
//  TaskManager.m
//  Diary
//
//  Created by Mac on 19.08.15.
//  Copyright (c) 2015 CEIT. All rights reserved.
//

#import "TaskManager.h"

@implementation TaskManager

typedef NSString* (^stringFromIntBlock)(int i, int j);

stringFromIntBlock myBlock = ^(int i, int j){
    return [NSString stringWithFormat:@"%d + %d", i, j];
};


typedef void (^voidBlock)(NSString* sting);

voidBlock myVoidBlock = ^(NSString* sting){
    NSLog(@"%@",sting);
};

- (void)voidBlockMethodWithBlock:(voidBlock)voidBlock
{
    //do wome stuff
    
    
    
    voidBlock(@"my string");
    voidBlock(@"another string");
}

- (void)blockTestMethodWithBlock:(stringFromIntBlock)testBlock
{
    // do smth
    testBlock(1,2);
}

- (dispatch_queue_t)background_queue
{
    return dispatch_queue_create("backgtound_queue", 0);
}


- (instancetype)init
{
    self = [super init];
    
    
    __block NSString *newString = @"123";
    
    dispatch_async([self background_queue], ^{
        [self blockTestMethodWithBlock:^NSString *(int i, int j) {
            NSString* someString =  [NSString stringWithFormat:@"%d + %d", i, j];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"time: %@",[NSDate date]);
                NSLog(@"%@, %@",newString,someString);
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // do some UI stuff here
                NSLog(@"time: %@",[NSDate date]);
                NSLog(@"%@",someString);
            });
            return someString;
        }];
    });
    
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Check if the access granted value for the events exists in the user defaults dictionary.
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
            // The value exists, so assign it to the property.
            self.eventsAccessGranted = [[userDefaults valueForKey:@"eventkit_events_access_granted"] intValue];
        }
        else{
            // Set the default value.
            self.eventsAccessGranted = NO;
            [self requestAccessToEvents];
        }

        /*
        // Load the selected calendar identifier.
        if ([userDefaults objectForKey:@"eventkit_selected_calendar"] != nil) {
            self.selectedCalendarIdentifier = [userDefaults objectForKey:@"eventkit_selected_calendar"];
        }
        else{
            self.selectedCalendarIdentifier = @"";
        }
         */
        
    }
    
    return self;
}

- (void)requestAccessToEvents
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.eventsAccessGranted = granted;
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)setEventsAccessGranted:(BOOL)eventsAccessGranted{
    _eventsAccessGranted = eventsAccessGranted;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

/*
- (NSArray *)getLocalEventCalendars{
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
    
    for (int i=0; i<allCalendars.count; i++) {
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        if (currentCalendar.type == EKCalendarTypeLocal) {
            [localCalendars addObject:currentCalendar];
        }
    }
    
    return (NSArray *)localCalendars;
}
 */

- (NSArray*)getEvents
{
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
    return events;
}

/*
-(void)setSelectedCalendarIdentifier:(NSString *)selectedCalendarIdentifier{
    _selectedCalendarIdentifier = selectedCalendarIdentifier;
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedCalendarIdentifier forKey:@"eventkit_selected_calendar"];
}
 */

@end
