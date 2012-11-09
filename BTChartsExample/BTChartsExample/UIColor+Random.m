//
//  UIColor+Random.m
//  ChartTest
//
//  Created by Cameron Cooke on 06/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


+ (UIColor *)randomPrimaryColour
{
    NSArray *colorArray = [NSArray arrayWithObjects:
                           [UIColor blackColor], [UIColor blueColor], [UIColor brownColor],
                           [UIColor cyanColor], [UIColor grayColor], [UIColor greenColor],
                           [UIColor magentaColor], [UIColor orangeColor],[UIColor purpleColor],
                           [UIColor redColor], [UIColor yellowColor], nil];
    
    UIColor *color = [colorArray objectAtIndex:(arc4random() % [colorArray count])];
    return color;
}

@end