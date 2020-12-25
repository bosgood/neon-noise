int cellSize = 16;
int tick = 0;
float colorRange = 1;
float colorStart = -100;
float colorSpeed = 0.1;

ArrayList<PVector> points = new ArrayList<PVector>();

void setup() {
  size(1024, 768);
  colorMode(HSB, 255, 255, 255);
}

void draw() {
  background(color(0, 0, 255));
  for (int i = 0; i < width / cellSize; i++) {
    for (int j = 0; j < height / cellSize; j++) {
      drawCell(i, j);
      // drawGrid(i, j);
    }
  }
  tick = (tick + 1);
  colorStart = (colorStart + colorSpeed);
  if (colorStart > 100 || colorStart < -100) {
    colorSpeed *= -1;
  }

  drawCursor();
  drawLegend();
  drawPoints();
}

// Generates the color at the given coordinates
color renderColorAt(int x, int y) {
  float scale = 0.001;
  float inc = tick * scale;
  int t = (int)map(inc, 0, 1, 0, 255);
  int sin = sinOsc(tick % 255);
  int noiseVal = inoise8(x * cellSize, y * cellSize, tick);
  int hue = (int) (colorStart + (colorRange * (sinOsc(t) * 0.25) + (int)(noiseVal * 0.75)));
  return color(constrain(hue, 0, 255), 125, 255, 255);
}

// Records mouse click locations
void mouseClicked() {
  points.add(new PVector(mouseX, mouseY));
  System.out.println("(" + mouseX + ", " + mouseY + ")");
}

// Draws all of the points that have been clicked
void drawPoints() {
  noFill();
  strokeWeight(1);
  stroke(color(0, 0, 0));
  for (int i = 0; i < points.size(); i++) {
    // Empty circle
    ellipse(points.get(i).x, points.get(i).y, 10, 10);
  }
}

void drawCursor() {
  noFill();
  stroke(color(0, 0, 0));
  strokeWeight(1);
  // Crosshairs
  line(mouseX, mouseY + 10, mouseX, mouseY + 25);
  line(mouseX, mouseY - 10, mouseX, mouseY - 25);
  line(mouseX + 10, mouseY, mouseX + 25, mouseY);
  line(mouseX - 10, mouseY, mouseX - 25, mouseY);
}

void drawLegend() {
  textSize(16);
  fill(color(0, 0, 0));
  // Example: (0, 0) 0 point(s) chosen
  text("(" + mouseX + ", " + mouseY + ") " + points.size() + " point(s) chosen", 25, 25);
  // Color shift status
  text("Color adjustment: " + colorStart, 25, 50);
}

void drawCell(int i, int j) {
  noStroke();
  fill(renderColorAt(i, j));
  rect(i * cellSize, j * cellSize, cellSize, cellSize);
}

// The Grid
void drawGrid(int i, int j) {
  stroke(color(0, 0, 0));
  strokeWeight(1);
  noFill();
  rect(i * cellSize, j * cellSize, cellSize, cellSize);
}

// Sine wave from 0-255, given a 0-255 time values
int sinOsc(int t) {
  int deg = (int)map(t, 0, 255, 0, 360);
  float rad = radians(deg);
  float wave = sin(rad);
  return (int)map(wave, -1, 1, 0, 255);
}

// FastLED compatibility
int inoise8(int x) {
  return intervalToEight(noise(eightToInterval(x)));
}

int inoise8(int x, int y) {
  return intervalToEight(noise(eightToInterval(x), eightToInterval(y)));
}

int inoise8(int x, int y, int z) {
  return intervalToEight(noise(eightToInterval(x), eightToInterval(y), eightToInterval(z)));
}

// Maps a 0-255 value to a 0-1 interval
float eightToInterval(int val) {
  return map(val, 0, 255, 0, 1);
}

// Maps a 0-1 interval to a 0-255 value
int intervalToEight(float val) {
  return (int)map(val, 0, 1, 0, 255);
}
