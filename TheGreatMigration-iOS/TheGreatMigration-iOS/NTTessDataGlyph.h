#import "NTGlyph.h"
#import "TessData.h"

class NTTessDataGlyph : public NTGlyph {

public:
    NTTessDataGlyph(char c, TessData *data);
    
    ~NTTessDataGlyph();
    
    TessData* getData();

protected:
    TessData* _data;
};