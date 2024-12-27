//
//  LSMenuView.h
//  GMenuController
//
//  Created by Frank on 12/27/24.
//

#import <UIKit/UIKit.h>
#import "GMenuControllerHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class GMenuItem, GMenuViewContainer;
@interface LSMenuView : UIView
@property (nonatomic, strong) NSArray<GMenuItem *> *menuItems;
@property (nonatomic, assign) CGSize maxSize;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, strong) UIColor *menuTintColor;
@property (nonatomic, assign) GMenuControllerArrowDirection CorrectDirection;
+ (instancetype)defaultView:(GMenuViewContainer *)container WithMenuItems:(NSArray<GMenuItem *> *)menuItems MaxSize:(CGSize)maxSize arrowSize:(CGSize)arrowSize AnchorPoint:(CGPoint)anchorPoint;
- (void)processLineWithMidX:(CGFloat)midX direction:(GMenuControllerArrowDirection)direction;
@end

NS_ASSUME_NONNULL_END
