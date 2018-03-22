#import <string.h>

#define PI 3.141592f
#define HALF_PI    (PI / 2.0f)
#define THIRD_PI   (PI / 3.0f)
#define TWO_PI     (PI * 2.0f)
#define QUARTER_PI (PI / 4.0f)
#define DEG_TO_RAD (PI/180.0f)
#define RAD_TO_DEG (180.0f/PI)
#define SINCOS_PRECISION (0.5f)
#define TEXT_FILE "TheGreatMigration.txt"


static const int BASE_FPS = 30;                                //target frames per second
static const float BG_COLOR[4] = {0.63f,0.89f,1.0f,1.0f};  //{0.37f,0.83f,1.0f,1.0f}     //background color
//static const int FONT_SIZE = 36;                          //font size
static const int WORD_SPACING = 20;                       //pixels between each word
static float BITMAP_FONT_SIZE = 0.85f;

static float BEAST_SIZE = 0.9f;        // avg size of beasts
static const float BEAST_ALPHA = 0.15;        //opacity of the beasts   /255
static const float BEAST_ANGLE_SPREAD = PI/6; //(PI/6)             //defines the maximum arc of a beasts tail
static const float BEAST_X_OFFSET = -50;                    //offset the text in the beast to adjust the lens effect
static const float BEAST_Y_OFFSET = 0;
static const int BEAST_LENGTH = 4;                        //number of words for each tail piece
static const int BEAST_RADIUS = 200;        //200              //radius of the beasts' lens effect
static const float BEAST_TARGET_RADIUS = 225.0f;      //225         //radius of the beasts' lens effect when touched
//static const int MIN_BEAST_Z = -350;                      //minimum z pos of a beast
//static const int MAX_BEAST_Z = 50;                     //maximum z position of a beast
static const int SPAWNING_BORDER = 300;    //10               //width of the border where the beasts spawn
//static const int NOISE_MIN_BEASTS = 1;                    //minimum number of beasts for noise calculation
//static const int NOISE_MAX_BEASTS = 15;                   //maximum number of beasts for noise calculation
//static const float NOISE_PERIOD_BEASTS = 500.0f;            //period noise calculation (bigger the number, the slower the change in maximum beasts)

static int MAX_BEASTS = 3;                         //maximum number of beasts
static int MAX_PRE_SPAWN_BEASTS = 2;          //max beasts on screen if beasts are right of first half
static int MIN_BEAST_Z = -350;                          //minimum beast z position
static int MAX_BEAST_Z = 50;                          //maximum beast z position

static const int READ_DISTANCE = 100;                     //radius that defines the hotspot to touch and grab a beast
static float CURRENT_DIRECTION = -PI - PI/64;       //direction of the current

static const float SPRAY_LIFETIME = 10;                 //seconds a sprayed word stays on screen
static const float SPRAY_FADE_PERIOD = 3;               //seconds it takes for a sprayed word to fade in/out
static const float SPRAY_COLOR[4] = {1.0f,1.0f,1.0f,0.4f};                //color of sprayed words, alpha
//static const int SPRAY_OPACITY = 0.5; //90                      //opacity of sprayed words
static const int SPRAY_WORDS_ON_TOUCH = 3;                //words to spray on first touch
static const int SPRAY_WORDS_ON_TOUCH_FORCE = 2;          //force with which the first sprayed word are pushed
#define SPRAY_INTERVAL 1.0f   //750          //interval (seconds) between sprayed words
#define SPRAY_LOOP_INTERVAL 2.5f;       //interval (seconds) between last and first sprayed word
#define SPRAY_FORCE 5.5f                 //release force of sprayed words
#define SPRAY_ANGULAR_FORCE 0.25f //0.25f    //angular release force of sprayed words; 50

static const float TOUCH_PUSH_RADIUS = 250;               //maximum radius effect of touch push
static const float TOUCH_PUSH_FORCE = 1.0f;                 //force multiplier to touch push


#define ATTENUATION 0.95           //motion attenuation factor
#define ANGULAR_ATTENUATION 0.98f;//0.95f   //rotation attenuation
#define BREATHING_SPEED 0.750f        //breathing (scaling) spread
#define BREATHING_SCALE 0.07f        //breathing scale (magnitude)
#define APPROACH_SPEED 0.8f          //speed to approach to touch
#define APPROACH_THRESHOLD 25          //approach threshold distance (hit distance)
#define CURRENT_STRENGTH 0.1f //0.2f        //strength of current

#define SCATTER_STRENGTH 0.40f     //strength of scatter behavior
#define SCATTER_ATTENUATION 0.03f  //attenuation of scatter behavior

#define TAIL_BEND_FACTOR 350         //bend factor for the tail behavior

//#define CAMOUFLAGE_MULTIPLIER 75.0f    //amount of opacity change by camouflage
#define CAMOUFLAGE_RATE 0.05f        //rate at which camouflage increases/decreases
#define CAMOUFLAGE_RED 0.8f             //red value of camouflage
#define CAMOUFLAGE_BLUE 0.96f            //blue value of camouflage
#define CAMOUFLAGE_GREEN    0.90f        //green value of camouflage
#define CAMOUFLAGE_ALPHA 0.5f            //alpha value of camouflage
#define RADIUS_RATE 5                //rate at which the radius 

#define TOUCH_FADE_RATE 0.1f


// TOUCH PARTICLES
#define TOUCH_PARTICLE_LIFE 1.0f             //life in millis of the touch particles
static const float TOUCH_PARTICLE_COLOR[4] = { 1.0f , 1.0f , 1.0f , 0.08f }; //20 << 24 | 255 << 16 | 255 << 8 | 255; //color of touch particles
#define TOUCH_PARTICLE_SPIN 0.1f              //touch particle spin
#define TOUCH_PARTICLE_PUSH 3.5f             //force of touch particle push
#define TOUCH_PARTICLE_SCALE 10              //initial scale of touch particles
//static float TOUCH_PARTICLE_MINIMUM_SIZE  = 0.3f;
//static float TOUCH_PARTICLE_MAXIMUM_SIZE  = 1.0f;
#define TOUCH_PARTICLE_DIST_THRESHOLD 350 // represents DeltaX + DeltaY, from touch point to beast


static bool RESUME_APP = NO;
static bool _DEBUG = NO;                //true to turn on debug mode (display extra info)