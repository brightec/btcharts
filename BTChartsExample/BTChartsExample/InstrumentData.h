//
//  InstrumentData.h
//  ChartTest
//
//  Created by Cameron Cooke on 07/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTPlotDataItem.h"

@interface InstrumentData : NSObject <BTPlotDataItem>
@property (nonatomic, copy) NSString *label;
@property (nonatomic) NSUInteger value;
@property (nonatomic, strong) UIColor *startGradientColour;
@property (nonatomic, strong) UIColor *endGradientColour;
@end
