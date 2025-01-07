//
//  LSMenuView.m
//  GMenuController
//
//  Created by Frank on 12/27/24.
//

#import "GAdjustButton.h"
#import "GMenuController.h"
#import "GMenuController_internal.h"
#import "GMenuDefaultView.h"
#import "GMenuViewContainer.h"
#import "LSMenuView.h"

@interface LSMenuView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) GMenuViewContainer *container;
@property (nonatomic, strong) NSMutableArray *lines;

@end

@implementation LSMenuView

+ (instancetype)defaultView:(GMenuViewContainer *)container WithMenuItems:(NSArray<GMenuItem *> *)menuItems MaxSize:(CGSize)maxSize arrowSize:(CGSize)arrowSize AnchorPoint:(CGPoint)anchorPoint
{
    LSMenuView *defaultView = [[LSMenuView alloc] initView:container WithMenuItems:menuItems MaxSize:maxSize arrowSize:arrowSize AnchorPoint:anchorPoint];

    return defaultView;
}

- (instancetype)initView:(GMenuViewContainer *)container WithMenuItems:(NSArray<GMenuItem *> *)menuItems MaxSize:(CGSize)maxSize arrowSize:(CGSize)arrowSize AnchorPoint:(CGPoint)anchorPoint
{
    if (self = [super init]) {
        //        self.backgroundColor = [UIColor grayColor];
        self.menuItems = menuItems;
        self.arrowSize = arrowSize;
        self.maxSize = maxSize;
        self.anchorPoint = anchorPoint;
        self.container = container;
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        self.menuTintColor = self.container.menuItemTintColor;
        self.contentView.layer.cornerRadius = self.container.cornerRadius;
        self.contentView.layer.masksToBounds = YES;

        [self layoutMenuViews:YES];
    }

    return self;
}

- (void)setCorrectDirection:(GMenuControllerArrowDirection)CorrectDirection {
}

- (void)processLineWithMidX:(CGFloat)midX direction:(GMenuControllerArrowDirection)direction {
}

- (void)layoutMenuViews:(BOOL)needResetLayout
{
    [self.lines removeAllObjects];

    NSArray *array = self.menuItems;
    NSUInteger itemsCount = array.count;
    NSInteger countPerLine = 4;
    CGFloat itemW = 70;
    CGFloat itemH = 64;

    if (self.container.menuItemFixWidth > 0) {
        itemW = self.container.menuItemFixWidth;
    }

    CGFloat totalWidth = MIN(countPerLine, itemsCount) * itemW;
    CGFloat totalHeight = ceil(itemsCount * 1.0 / countPerLine) * itemH;

    [array enumerateObjectsUsingBlock:^(GMenuItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSInteger row = idx / countPerLine;
        NSInteger column = idx % countPerLine;

        GMenuItemDefaultView *item = [GMenuItemDefaultView buttonWithType:UIButtonTypeCustom];
        [item      addTarget:obj.target
                      action:obj.action
            forControlEvents:UIControlEventTouchUpInside];
        item.frame = CGRectMake(column * itemW, row * itemH, itemW, itemH);
        [item setTitle:obj.title
              forState:UIControlStateNormal];
        item.titleLabel.font = self.container.menuItemFont;
        [item setTitleColor:self.menuTintColor ? : [UIColor whiteColor]
                   forState:UIControlStateNormal];
        item.highlightedColor = self.container.menuItemHighlightColor;
        [self.contentView addSubview:item];

        if (obj.image) {
            item.imagePosition = self.container.imagePosition;
            [item setImage:obj.image
                  forState:UIControlStateNormal];
        }

        if (itemsCount > 1 && idx != itemsCount - 1 && column != countPerLine - 1) {
            UIView *line = [UIView new];
            UIColor *bgColor = self.container.menuItemLineColor ? : self.menuTintColor;
            line.backgroundColor =  bgColor ? : [UIColor whiteColor];
            [self addSubview:line];
            line.frame = CGRectMake(CGRectGetMaxX(item.frame), CGRectGetMidY(item.frame) - 30 / 2, 1 / [UIScreen mainScreen].scale, 30);
            [self.lines addObject:line];
        }
    }];

    if (needResetLayout) {
        self.contentView.frame = CGRectMake(0, 0, totalWidth, totalHeight);
        self.frame = CGRectMake(0, 0, totalWidth, totalHeight + _arrowSize.height);
    }

    [self setCorrectDirection:_CorrectDirection];
}

- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray array];
    }

    return _lines;
}

@end
