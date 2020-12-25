#include <FastLED.h> // Written for v3.4.0

#define NUM_LEDS 20
#define DATA_PIN 14

CRGB leds[NUM_LEDS];

void setup()
{
  // FastLED setup
  FastLED.addLeds<WS2811, DATA_PIN, RGB>(leds, NUM_LEDS);
}

uint8_t hue = 0;

void loop()
{
  hue = (hue + 1) % 255;
  FastLED.showColor(CHSV(hue++, 255, 255));
  delay(50);
}
