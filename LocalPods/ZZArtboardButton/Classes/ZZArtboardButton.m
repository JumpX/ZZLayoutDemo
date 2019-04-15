//
//  ZZArtboardButton.m
//  ZZArtboardButton
//
//  Created by Jungle on 2019/3/25.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZArtboardButton.h"

CGFloat const kArtboardUpDownHeight = 44.0f;

static NSString * const kUpNormalFromColor = @"#2FCEFF";
static NSString * const kUpNormalToColor = @"#39A7FF";
static NSString * const kDownNormalTitleColor = @"#1D9AFF";
static NSString * const kDownNormalBorderLayerColor = @"#2399FF";
static NSString * const kDownDisbaledBackgroundColor = @"#C8C8C8";
static NSString * const kDownDisbaledBorderLayerColor = @"#E1E1E1";

@interface UIView (ZZArtboardButton)

- (UIImage *)snapshotImage;

@end

@implementation UIView (ZZArtboardButton)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end

@interface CALayer (ZZArtboardButton)

- (UIImage *)snapshotImage;

@end

@implementation CALayer (ZZArtboardButton)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@interface ZZArtboardButton ()

@property (nonatomic, assign)   ZZArtboardType      type;
@property (nonatomic, assign)   CGSize              currentSize;

@property (nonatomic, strong)   UIImage             *custom_normalImage;
@property (nonatomic, strong)   UIImage             *custom_highlightedImage;
@property (nonatomic, strong)   UIImage             *custom_selectedImage;
@property (nonatomic, strong)   UIImage             *custom_disabledImage;

@property (nonatomic, strong)   UIImage             *up_normalImage;
@property (nonatomic, strong)   UIImage             *up_highlightedImage;
@property (nonatomic, strong)   UIImage             *up_disabledImage;

@property (nonatomic, strong)   UIImage             *down_normalImage;
@property (nonatomic, strong)   UIImage             *down_highlightedImage;
@property (nonatomic, strong)   UIImage             *down_disabledImage;

@end

@implementation ZZArtboardButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    ZZArtboardButton *button = [super buttonWithType:buttonType];
    if (button) {
        button.bxAdjustsWhenHighlighted = YES;
        button.layer.masksToBounds = YES;
    }
    return button;
}

- (void)setType:(ZZArtboardType)type textColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text {
    [self.titleLabel setFont:font];
    [self setTitle:text forState:UIControlStateNormal];
    _type = type;
    switch (type) {
        case ZZArtboardTypeUp: {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case ZZArtboardTypeDown: {
            [self setTitleColor:[UIColor colorWithHex:kDownNormalTitleColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        }
            break;
        case ZZArtboardTypeCustom: {
            [self setTitleColor:textColor forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGSizeEqualToSize(_currentSize, self.bounds.size)) {
        _currentSize = self.bounds.size;
        self.layer.cornerRadius = _currentSize.height/2.0;
        switch (_type) {
            case ZZArtboardTypeUp: {
                [self resetUpStyle];
            }
                break;
            case ZZArtboardTypeDown: {
                [self resetDownStyle];
            }
                break;
            case ZZArtboardTypeCustom: {
                if (self.layoutCustomBackgroundImageBlock) {
                    self.layoutCustomBackgroundImageBlock();
                }
            }
                break;
                
            default:
                break;
        }
    }
    _currentSize = self.bounds.size;
}

#pragma mark - Test

- (void)setCustomTitles {
    
    [self setTitle:@"自定义 正常状态" forState:UIControlStateNormal];
    //    [self setTitle:@"自定义 高亮状态" forState:UIControlStateHighlighted];
    [self setTitle:@"自定义 选中状态" forState:UIControlStateHighlighted | UIControlStateSelected];
    [self setTitle:@"自定义 选中状态" forState:UIControlStateSelected];
    [self setTitle:@"自定义 无效状态" forState:UIControlStateDisabled];
}

- (void)setUpTitles {
    [self setTitle:@"类型一 正常状态" forState:UIControlStateNormal];
    [self setTitle:@"类型一 高亮状态" forState:UIControlStateHighlighted];
    [self setTitle:@"类型一 高亮状态" forState:UIControlStateHighlighted | UIControlStateSelected];
    [self setTitle:@"类型一 无效状态" forState:UIControlStateDisabled];
}

- (void)setDownTitles {
    [self setTitle:@"类型二 正常状态" forState:UIControlStateNormal];
    [self setTitle:@"类型二 高亮状态" forState:UIControlStateHighlighted];
    [self setTitle:@"类型二 高亮状态" forState:UIControlStateHighlighted | UIControlStateSelected];
    [self setTitle:@"类型二 无效状态" forState:UIControlStateDisabled];
}

#pragma mark - Private

- (void)resetUpStyle {
    _up_normalImage = nil;
    _up_highlightedImage = nil;
    _up_disabledImage = nil;
    [self clearAllBackgroundImages];
    [self setUpNormalStyleWithNormalState];
    [self setUpHighlightedStyleWithHighlightedState];
    [self setUpDisabledStyleWithDisabledState];
}

- (void)resetDownStyle {
    _down_normalImage = nil;
    _down_highlightedImage = nil;
    _down_disabledImage = nil;
    [self clearAllBackgroundImages];
    [self setDownNormalStyleWithNormalState];
    [self setDownHighlightedStyleWithHighlightedState];
    [self setDownDisabledStyleWithDisabledState];
}

- (void)resetCustomStyle {
    _custom_normalImage = nil;
    _custom_highlightedImage = nil;
    _custom_selectedImage = nil;
    _custom_disabledImage = nil;
    [self clearAllBackgroundImages];
}

#pragma mark - Setter

- (void)setBxAdjustsWhenHighlighted:(BOOL)bxAdjustsWhenHighlighted {
    _bxAdjustsWhenHighlighted = bxAdjustsWhenHighlighted;
    if (bxAdjustsWhenHighlighted) {
        self.adjustsImageWhenHighlighted = YES;
    } else {
        self.adjustsImageWhenHighlighted = NO;
        NSString *selectedTitle = [self titleForState:UIControlStateSelected];
        if (selectedTitle && selectedTitle.length > 0) {
            [self setTitle:selectedTitle forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        UIImage *selectedBackgroundImage = [self backgroundImageForState:UIControlStateSelected];
        if (selectedBackgroundImage) {
            [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected | UIControlStateHighlighted];
        }
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    if (!_bxAdjustsWhenHighlighted) {
        if (state == UIControlStateSelected) {
            [super setTitle:title forState:UIControlStateSelected | UIControlStateHighlighted];
        }
    }
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [super setBackgroundImage:image forState:state];
    if (!self.bxAdjustsWhenHighlighted) {
        if (state == UIControlStateSelected) {
            [super setBackgroundImage:image forState:UIControlStateSelected | UIControlStateHighlighted];
        }
    }
}

#pragma mark - Custom Public

/* 自定义类型 使用蓝条 */

- (void)setUpNormalStyleWithNormalState {
    [self setUpNormalStyleWithState:UIControlStateNormal];
}

- (void)setUpHighlightedStyleWithHighlightedState {
    [self setUpHighlightedStyleWithState:UIControlStateHighlighted];
    [self setUpHighlightedStyleWithState:UIControlStateHighlighted | UIControlStateSelected];
}

- (void)setUpDisabledStyleWithDisabledState {
    [self setUpDisabledStyleWithState:UIControlStateDisabled];
}

- (void)setUpNormalStyleWithState:(UIControlState)state {
    [self setBackgroundImage:self.up_normalImage forState:state];
}

- (void)setUpHighlightedStyleWithState:(UIControlState)state {
    [self setBackgroundImage:self.up_highlightedImage forState:state];
}

- (void)setUpDisabledStyleWithState:(UIControlState)state {
    [self setBackgroundImage:self.up_disabledImage forState:state];
}

/* 自定义类型 使用白条 */

- (void)setDownNormalStyleWithNormalState {
    [self setDownNormalStyleWithState:UIControlStateNormal];
}

- (void)setDownHighlightedStyleWithHighlightedState {
    [self setDownHighlightedStyleWithState:UIControlStateHighlighted];
    [self setDownHighlightedStyleWithState:UIControlStateHighlighted | UIControlStateSelected];
}

- (void)setDownDisabledStyleWithDisabledState {
    [self setDownDisabledStyleWithState:UIControlStateDisabled];
}

- (void)setDownNormalStyleWithState:(UIControlState)state {
    [self setBackgroundImage:self.down_normalImage forState:state];
}

- (void)setDownHighlightedStyleWithState:(UIControlState)state {
    [self setBackgroundImage:self.down_highlightedImage forState:state];
}

- (void)setDownDisabledStyleWithState:(UIControlState)state {
    [self setBackgroundImage:self.down_disabledImage forState:state];
}

/* 清除所有状态下背景图 */

- (void)clearAllBackgroundImages {
    [self setBackgroundImage:nil  forState:UIControlStateNormal];
    [self setBackgroundImage:nil  forState:UIControlStateHighlighted];
    [self setBackgroundImage:nil  forState:UIControlStateHighlighted | UIControlStateSelected];
    [self setBackgroundImage:nil  forState:UIControlStateSelected];
    [self setBackgroundImage:nil  forState:UIControlStateDisabled];
}

/* 设置背景图 */

- (void)setBackgroundImageWithColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    CALayer *layer = [self maskLayerWithFrame:self.bounds color:backgroundColor];
    UIImage *image = [layer snapshotImage];
    [self setBackgroundImage:image forState:state];
}

- (void)setBackgroundImageWithColor:(UIColor *)backgroundColor boderColor:(UIColor *)boderColor forState:(UIControlState)state {
    CALayer *layer = [self createLayerWithFrame:self.bounds bgColor:backgroundColor borderColor:boderColor];
    UIImage *image = [layer snapshotImage];
    [self setBackgroundImage:image forState:state];
}

- (void)setBackgroundImageWithColors:(NSArray *)backgroundColors forState:(UIControlState)state {
    CAGradientLayer *gradientLayer = [self gradientLayerWithFrame:self.bounds colors:backgroundColors directionType:ZZArtboardDirectionTypeDefault];
    UIImage *image = [gradientLayer snapshotImage];
    [self setBackgroundImage:image forState:state];
}

- (void)setBackgroundImageWithColors:(NSArray<UIColor *> *)backgroundColors boderColor:(UIColor *)boderColor forState:(UIControlState)state {
    CAGradientLayer *gradientLayer = [self gradientLayerWithFrame:self.bounds colors:backgroundColors directionType:ZZArtboardDirectionTypeDefault];
    gradientLayer.borderWidth = 1.0;
    gradientLayer.cornerRadius = self.bounds.size.height/2.0;
    gradientLayer.borderColor = boderColor.CGColor;
    UIImage *image = [gradientLayer snapshotImage];
    [self setBackgroundImage:image forState:state];
}

- (void)setBackgroundImageWithColors:(NSArray<UIColor *> *)backgroundColors forState:(UIControlState)state directionType:(ZZArtboardDirectionType)directionType {
    CAGradientLayer *gradientLayer = [self gradientLayerWithFrame:self.bounds colors:backgroundColors directionType:directionType];
    UIImage *image = [gradientLayer snapshotImage];
    [self setBackgroundImage:image forState:state];
}

- (void)setBackgroundImageWithColors:(NSArray<UIColor *> *)backgroundColors boderColor:(UIColor *)boderColor forState:(UIControlState)state directionType:(ZZArtboardDirectionType)directionType {
    CAGradientLayer *gradientLayer = [self gradientLayerWithFrame:self.bounds colors:backgroundColors directionType:directionType];
    gradientLayer.borderWidth = 1.0;
    gradientLayer.cornerRadius = self.bounds.size.height/2.0;
    gradientLayer.borderColor = boderColor.CGColor;
    UIImage *image = [gradientLayer snapshotImage];
    [self setBackgroundImage:image forState:state];
}

/* 渐变图层 */

- (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame colors:(NSArray <UIColor *>*)colors directionType:(ZZArtboardDirectionType)directionType {
    NSInteger count = colors.count;
    if (colors.count <= 0) {
        return [CAGradientLayer layer];
    }
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    switch (directionType) {
        case ZZArtboardDirectionTypeDefault: {
            startPoint = CGPointMake(0, 1.0);
            endPoint = CGPointMake(1.0, 0);
        }
            break;
        case ZZArtboardDirectionTypeTopToBottom: {
            startPoint = CGPointMake(0.5, 0);
            endPoint = CGPointMake(0.5, 1.0);
        }
            break;
        case ZZArtboardDirectionTypeLeftToRight: {
            startPoint = CGPointMake(0, 0.5);
            endPoint = CGPointMake(1.0, 0.5);
        }
            break;
        case ZZArtboardDirectionTypeLeftTopToRightBottom: {
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(1.0, 1.0);
        }
            
        default:
            break;
    }
    NSMutableArray *cgColors = [NSMutableArray array];
    NSMutableArray *locations = [NSMutableArray array];
    if (count == 1) {
        [locations addObject:@(0)];
        [locations addObject:@(1.0)];
        [cgColors addObject:(__bridge id)colors[0].CGColor];
        [cgColors addObject:(__bridge id)colors[0].CGColor];
    } else {
        CGFloat perLocation = 1.0/(count-1);
        for (NSInteger i = 0; i < count; i ++) {
            [locations addObject:@(perLocation*i)];
        }
        for (NSInteger i = 0; i < count; i ++) {
            [cgColors addObject:(__bridge id)colors[i].CGColor];
        }
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.type = kCAGradientLayerAxial;
    gradientLayer.colors = [cgColors copy];
    gradientLayer.locations = [locations copy];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = frame;
    return gradientLayer;
}

- (CALayer *)createLayerWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = bgColor.CGColor;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = 1.0;
    layer.cornerRadius = frame.size.height/2.0;
    layer.masksToBounds = YES;
    layer.frame = frame;
    return layer;
}

- (CALayer *)maskLayerWithFrame:(CGRect)frame color:(UIColor *)color {
    CALayer *maskLayer = [CALayer layer];
    maskLayer.backgroundColor = color.CGColor;
    maskLayer.frame = frame;
    return maskLayer;
}

+ (void)setShadowWithLayer:(CALayer *)layer color:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity height:(CGFloat)height {
    layer.shadowOffset = offset;
    layer.shadowColor = color.CGColor;
    layer.shadowRadius = radius;
    layer.shadowOpacity = opacity;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, layer.frame.size.height - height / 2, layer.frame.size.width, height)];
    layer.shadowPath = path.CGPath;
}

#pragma mark - Getter

- (UIImage *)up_normalImage {
    if (!_up_normalImage) {
        CAGradientLayer *gradientLayer = [self gradientLayerWithFrame:self.bounds colors:@[[UIColor colorWithHex:kUpNormalFromColor], [UIColor colorWithHex:kUpNormalToColor]] directionType:ZZArtboardDirectionTypeDefault];
        _up_normalImage = [gradientLayer snapshotImage];
    }
    return _up_normalImage;
}

- (UIImage *)up_highlightedImage {
    if (!_up_highlightedImage) {
        CAGradientLayer *gradientLayer = [self gradientLayerWithFrame:self.bounds colors:@[[UIColor colorWithHex:kUpNormalFromColor], [UIColor colorWithHex:kUpNormalToColor]] directionType:ZZArtboardDirectionTypeDefault];
        CALayer *maskLayer = [self maskLayerWithFrame:self.bounds color:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
        [gradientLayer addSublayer:maskLayer];
        _up_highlightedImage = [gradientLayer snapshotImage];
    }
    return _up_highlightedImage;
}

- (UIImage *)up_disabledImage {
    if (!_up_disabledImage) {
        CAGradientLayer *gradientLayer = [self gradientLayerWithFrame:self.bounds colors:@[[[UIColor colorWithHex:kUpNormalFromColor] colorWithAlphaComponent:0.5], [[UIColor colorWithHex:kUpNormalToColor] colorWithAlphaComponent:0.5]] directionType:ZZArtboardDirectionTypeDefault];
        _up_disabledImage = [gradientLayer snapshotImage];
    }
    return _up_disabledImage;
}

- (UIImage *)down_normalImage {
    if (!_down_normalImage) {
        CALayer *layer = [self createLayerWithFrame:self.bounds bgColor:[UIColor whiteColor] borderColor:[UIColor colorWithHex:kDownNormalBorderLayerColor]];
        _down_normalImage = [layer snapshotImage];
    }
    return _down_normalImage;
}

- (UIImage *)down_highlightedImage {
    if (!_down_highlightedImage) {
        CALayer *layer = [self createLayerWithFrame:self.bounds bgColor:[UIColor whiteColor] borderColor:[UIColor colorWithHex:kDownNormalBorderLayerColor]];
        CALayer *maskLayer = [self maskLayerWithFrame:self.bounds color:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
        [layer addSublayer:maskLayer];
        _down_highlightedImage = [layer snapshotImage];
    }
    return _down_highlightedImage;
}

- (UIImage *)down_disabledImage {
    if (!_down_disabledImage) {
        CALayer *layer = [self createLayerWithFrame:self.bounds bgColor:[UIColor colorWithHex:kDownDisbaledBackgroundColor] borderColor:[UIColor colorWithHex:kDownDisbaledBorderLayerColor]];
        _down_disabledImage = [layer snapshotImage];
    }
    return _down_disabledImage;
}

@end
