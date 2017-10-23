//
//  BRTextView.m
//  BRTextView
//
//  Created by Archy on 2017/10/20.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "BRTextView.h"

@interface BRTextView () <NSLayoutManagerDelegate>

@property (strong, nonatomic) UIView  *underline;
@property (strong, nonatomic) UILabel *lblPlaceholder;
@property (assign, nonatomic) CGFloat  maxHeight;
@property (assign, nonatomic) CGFloat  minHeight;

@end

@implementation BRTextView

- (instancetype)init {
    if (self = [super init]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self propertyInit];
        [self updateUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = self.textInsets;
    CGFloat height = [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height;
    if (self.minHeight > 0) {
        height = height > self.minHeight ? height : self.minHeight;
    }
    if (self.maxHeight > 0) {
        height = height > self.maxHeight ? self.maxHeight : height;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    [self updateFrame];
}

- (void)propertyInit {
    self.needUnderLine = YES;
    self.font = [UIFont systemFontOfSize:17];
    self.placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22];
    self.maximumNumberOfLines = 1;
    self.lineSpacing = 6;
}

- (void)updateUI {
    [self addSubview:self.underline];
    [self addSubview:self.lblPlaceholder];
    self.layoutManager.delegate = self;
    self.layoutManager.allowsNonContiguousLayout = NO;
    [self updateFrame];
    [self addObserverOrAction];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateFrame {
    self.lblPlaceholder.frame = CGRectMake(self.textContainerInset.left, self.textContainerInset.top, self.contentSize.width - self.textContainerInset.left - self.textContainerInset.right, self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom);
    self.underline.frame = CGRectMake(0, self.bounds.size.height - 0.5 + self.bounds.origin.y, self.bounds.size.width, 0.5);
}

- (void)prepareForInterfaceBuilder {
    self.lblPlaceholder.frame = CGRectMake(self.textContainerInset.left, self.textContainerInset.top, self.contentSize.width - self.textContainerInset.left - self.textContainerInset.right, self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom);
    self.underline.frame = CGRectMake(0, self.bounds.size.height - 0.5 + self.bounds.origin.y, self.bounds.size.width, 0.5);
}

- (void)addObserverOrAction {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputDidChange) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputDidBegin) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputDidEnd) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (CGSize)intrinsicContentSize {
    CGFloat height = [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height;
    if (self.maxHeight > 0) {
        height = height > self.maxHeight ? self.maxHeight : height;
    }
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return self.lineSpacing;
}

#pragma mark - Control Events
- (void)inputDidBegin {
}

- (void)inputDidEnd{
}

- (void)inputDidChange{
    self.lblPlaceholder.hidden = self.text.length > 0;
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Private
- (void)updateMinAndMaxHeight {
    CGFloat lineSpacing = self.lineSpacing;
    _maxHeight = self.maximumNumberOfLines * self.font.lineHeight + lineSpacing * self.maximumNumberOfLines + self.textInsets.top + self.textInsets.bottom;
    _minHeight = self.font.lineHeight + lineSpacing + self.textInsets.top + self.textInsets.bottom ;
    [self setNeedsLayout];
}

#pragma mark - Setter & Getter
#pragma mark - Setter
- (void)setNeedUnderLine:(BOOL)needUnderLine {
    _needUnderLine = needUnderLine;
    self.underline.hidden = !needUnderLine;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
    self.underline.backgroundColor = underlineColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.lblPlaceholder.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.lblPlaceholder.textColor = placeholderColor;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    [self updateMinAndMaxHeight];
}

- (void)setIb_textInsets:(NSString *)ib_textInsets {
    _ib_textInsets = ib_textInsets;
    [self setTextInsets:UIEdgeInsetsFromString(ib_textInsets)];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    [self updateMinAndMaxHeight];
}

- (void)setMaximumNumberOfLines:(NSInteger)maximumNumberOfLines {
    _maximumNumberOfLines = maximumNumberOfLines;
    [self updateMinAndMaxHeight];
}

#pragma mark - Super Setter
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.lblPlaceholder.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.lblPlaceholder.font = font;
    [self updateMinAndMaxHeight];
}
#pragma mark - Getter

- (UILabel *)lblPlaceholder {
    if (!_lblPlaceholder) {
        _lblPlaceholder = [[UILabel alloc] initWithFrame:self.bounds];
        _lblPlaceholder.textColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.22];
        _lblPlaceholder.textAlignment = self.textAlignment;
        _lblPlaceholder.font = self.font;
        _lblPlaceholder.numberOfLines = 0;
    }
    return _lblPlaceholder;
}

- (UIView *)underline {
    if (!_underline) {
        _underline = [[UIView alloc] init];
        _underline.backgroundColor = [UIColor lightGrayColor];
    }
    return _underline;
}

@end
