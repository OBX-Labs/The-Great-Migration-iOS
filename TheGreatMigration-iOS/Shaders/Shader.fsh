//
//  Shader.fsh
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-04-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
