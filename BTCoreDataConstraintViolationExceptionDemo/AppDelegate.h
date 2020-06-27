//
//  AppDelegate.h
//  BTCoreDataConstraintViolationExceptionDemo
//
//  Created by Daria on 27.06.2020.
//  Copyright © 2020 Beat Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

