//
//  BRTextView.h
//  BRTextView
//
//  Created by Archy on 2017/10/20.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BRTextView : UITextView
/**
 Whether Need Underline. default is YES. line width is 1;
 */
@property (assign, nonatomic, getter=isNeedUnderline)IBInspectable BOOL needUnderLine;

@property (nullable, nonatomic, strong) IBInspectable UIColor     *underlineColor;

@property (nullable, nonatomic, copy)IBInspectable   NSString      *placeholder;          // default is nil. string is drawn 70% gray
@property (nullable, nonatomic, strong)IBInspectable UIColor                *placeholderColor;            // default is nil. use opaque black

@property (assign, nonatomic) UIEdgeInsets textInsets;
@property (nullable, nonatomic, copy) IBInspectable NSString *ib_textInsets;
@property (assign, nonatomic) IBInspectable CGFloat lineSpacing;
@property (assign, nonatomic) IBInspectable NSInteger maximumNumberOfLines;

@end
