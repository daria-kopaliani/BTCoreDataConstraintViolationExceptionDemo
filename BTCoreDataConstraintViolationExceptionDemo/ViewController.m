//
//  ViewController.m
//  BTCoreDataConstraintViolationExceptionDemo
//
//  Created by Daria on 27.06.2020.
//  Copyright © 2020 Beat Technology. All rights reserved.
//

#import "ViewController.h"

#import "BTEntity+CoreDataClass.h"
#import "BTEntity+CoreDataProperties.h"
@import CoreData;


@interface ViewController ()

@property (nonatomic, weak) IBOutlet UISlider *slider;

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end


@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.slider.enabled = YES;

    self.persistentContainer = [NSPersistentContainer persistentContainerWithName:@"BTCoreDataConstraintViolationExceptionDemo"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext *context) {
                
                context.undoManager = nil;
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
                context.automaticallyMergesChangesFromParent = YES;
                NSFetchRequest *fetchRequest = [BTEntity fetchRequest];
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", @"FixtureID"];
                NSError *error = nil;
                NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
                if (error) {
                    NSLog(@"Error: %@", error);
                } else if (fetchedObjects.count) {
                    if (fetchedObjects.count > 1) {
                        NSLog(@"Multiple `BTEntity` found!");
                    }
                    CGFloat value = [((BTEntity *)[fetchedObjects firstObject]).value floatValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.slider.value = value;
                        self.slider.enabled = YES;
                    });
                }
            }];
        }
    }];
}

- (IBAction)sliderValueChanged:(UISlider *)slider {
    
    [self persistValue:slider.value];
}

- (void)persistValue:(float)value {
    
    [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext *context) {
       
        context.undoManager = nil;
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        context.automaticallyMergesChangesFromParent = YES;
        
        BTEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"BTEntity" inManagedObjectContext:context];
        entity.id = @"FixtureID";
        entity.value = @(value);
        NSError *error = nil;
        [context save:&error];
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Persisted %.2f", value);
        }
    }];
}

@end
