//
//  Place.h
//  WhereAmI
//
//  Created by Joe on 11/2/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Place : NSObject<MKAnnotation>

@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *subtitle;
@property (assign,nonatomic)CLLocationCoordinate2D coordinate;

@end
