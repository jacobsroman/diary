//
//  TaskManager.h
//  Diary
//
//  Created by Mac on 19.08.15.
//  Copyright (c) 2015 CEIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@interface TaskManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;
//@property (nonatomic, strong) NSString* selectedCalendarIdentifier;

- (void)requestAccessToEvents;
- (NSArray*)getEvents;

@end
