#include <FastLED.h> // Written for v3.4.0

#define NUM_LEDS 20
#define DATA_PIN 14
#define CELL_SIZE 64
#define COLOR_RANGE 1
#define COLOR_SPEED 0.02
#define COLOR_SCALE 0.002
#define REFRESH_DELAY 20
#define SATURATION 200
#define VALUE 255
#define BRIGHTNESS 150
#define COLOR_START 100

struct Point
{
  uint16_t x;
  uint16_t y;
};

float colorStart = -COLOR_START;
float colorSpeed = COLOR_SPEED;
uint16_t tick = 0;
CRGB leds[NUM_LEDS];
Point points[NUM_LEDS] = {
    {334, 139},
    {290, 232},
    {465, 66},
    {278, 333},
    {283, 441},
    {293, 538},
    {335, 631},
    {398, 695},
    {499, 708},
    {596, 709},
    {672, 669},
    {712, 608},
    {733, 530},
    {753, 444},
    {767, 359},
    {777, 279},
    {779, 200},
    {745, 125},
    {674, 71},
    {588, 59},
};

void setup()
{
  FastLED.addLeds<WS2811, DATA_PIN, RGB>(leds, NUM_LEDS);
  LEDS.setBrightness(BRIGHTNESS);
}

void loop()
{
  tick++;
  colorStart = (colorStart + colorSpeed);
  if (colorStart > 100 || colorStart < -100)
  {
    colorSpeed *= -1;
  }

  for (uint8_t i = 0; i < NUM_LEDS; i++)
  {
    Point p = points[i];
    uint8_t hue = renderHueAt(tick, p.x, p.y);
    leds[i] = CHSV(hue, SATURATION, VALUE);
  }
  FastLED.show();

  delay(REFRESH_DELAY);
}

// Generates the hue at the given coordinates
uint8_t renderHueAt(uint16_t t, uint16_t x, uint16_t y)
{
  float inc = t * COLOR_SCALE;
  uint8_t t2 = (uint8_t)map(inc, 0, 1, 0, 255);
  uint8_t sin = sinOsc(t % 255);
  uint8_t noiseVal = inoise8(x * CELL_SIZE, y * CELL_SIZE, t);
  uint8_t hue = (uint8_t)(colorStart + (COLOR_RANGE * (sinOsc(t2) * 0.25) + (uint8_t)(noiseVal * 0.75)));
  return constrain(hue, 0, 255);
}

// Sine wave from 0-255, given a 0-255 time values
uint8_t sinOsc(uint8_t t)
{
  uint16_t deg = (uint16_t)map(t, 0, 255, 0, 360);
  float rad = radians(deg);
  float wave = sin(rad);
  return (uint8_t)map(wave, -1, 1, 0, 255);
}
