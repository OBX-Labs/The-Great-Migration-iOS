//
//  PreCalcTable.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-06-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//class PreCalcTables
//{
//    
//public:
    static int SINCOS_LENGTH;
    static float* sinLUT;
    static float* cosLUT;
    static bool initCalcTables_flag;
    
    
    static void initCalcTables(){
        if (!initCalcTables_flag) {
            
            initCalcTables_flag = true;
            
            SINCOS_LENGTH = (int) (360.0f / SINCOS_PRECISION);
            
            //float* tmpSinLut[SINCOS_LENGTH];
            //float[SINCOS_LENGTH]
            sinLUT = new float[SINCOS_LENGTH];
            cosLUT = new float[SINCOS_LENGTH];
            
            
            for (int i = 0; i < SINCOS_LENGTH; i++) {
                sinLUT[i] = (float) sin(i * DEG_TO_RAD * SINCOS_PRECISION);
                cosLUT[i] = (float) cos(i * DEG_TO_RAD * SINCOS_PRECISION);
            }
        }
        
    }
    
//};
