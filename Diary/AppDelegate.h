//
//  AppDelegate.h
//  Diary
//
//  Created by Mac on 08.08.15.
//  Copyright (c) 2015 CEIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) CoreDataManager* dataManager;

@property (strong, nonatomic) UIWindow *window;

@end

