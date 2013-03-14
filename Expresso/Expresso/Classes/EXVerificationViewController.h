//
//  EXVerificationViewController.h
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXSession.h"

/**
 *  View controller for the symbol recognition verification stage.
 *  User interacts with recognized characters, approving & correcting
 *  them all.
 */

@interface EXVerificationViewController : UIViewController

/** The UIBarButtonItem that moves us forward. */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
/** The current EXSession. */
@property (strong, nonatomic) EXSession *session;
/** An array of bounding boxes (EXSymbolView objects). */
@property (strong, nonatomic) NSArray *boundingBoxes;
/** The view holding our expression's image. */
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/** Are our bounding boxes showing? */
@property (readwrite, nonatomic) BOOL boundingBoxesShowing;

/**
 * Toggle the bounding boxes.
 *
 * @param sender The sending object.
 */
- (IBAction)toggleBoundingBoxes:(id)sender;

/**
 * Send us back to the Welcome view.
 *
 * @param sender The sending object.
 */
- (IBAction)startOver:(id)sender;

/**
 *  A symbolView was touched -- display its editing and modification view.
 *
 *  @param sender The sending object.
 */
- (void)symbolSelected:(id)sender;

@end
