//
//  PhysicsCategories.h
//  TextShooter
//
//  Created by Joe on 11/29/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#ifndef PhysicsCategories_h
#define PhysicsCategories_h

typedef NS_OPTIONS(uint32_t,PhysicsCategory){
    PlayerCategory=1<<1,
    EnemyCategory=1<<2,
    PlayerMissileCategory=1<<3,
    GravityFieldCategory=1<<4
};

#endif /* PhysicsCategories_h */
