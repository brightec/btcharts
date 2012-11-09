//
//  InstrumentsDateGroup.h
//  ChartTest
//
//  Created by Cameron Cooke on 07/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTPlotGroupDataItem.h"

@interface InstrumentsDateGroup : NSObject <BTPlotGroupDataItem>
@property (nonatomic, copy) NSString *label;
@property (nonatomic, strong) NSArray *plotDataItems;
@end
