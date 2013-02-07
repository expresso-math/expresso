//
//  EXModelController.h
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXDataViewController;

@interface EXModelController : NSObject <UIPageViewControllerDataSource>

- (EXDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(EXDataViewController *)viewController;

@end
