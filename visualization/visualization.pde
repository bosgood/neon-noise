int cellSize = 16;
int tick = 0;

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

  drawCursor();
  drawLegend();
  drawPoints();
}

// Records mouse click locations
void mouseClicked() {
  points.add(new PVector(mouseX, mouseY));
  System.out.println("(" + mouseX + ", " + mouseY + ")");
}

void drawPoints() {
  noFill();
  strokeWeight(1);
  stroke(color(0, 0, 0));
  for (int i = 0; i < points.size(); i++) {
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
  text("(" + mouseX + ", " + mouseY + ") " + points.size() + " point(s) chosen", 25, 25);
}

void drawCell(int i, int j) {
  noStroke();
  fill(render(i, j));
  rect(i * cellSize, j * cellSize, cellSize, cellSize);
}

void drawGrid(int i, int j) {
  // The Grid
  stroke(color(0, 0, 0));
  strokeWeight(1);
  noFill();
  rect(i * cellSize, j * cellSize, cellSize, cellSize);
}

color render(int x, int y) {
  float scale = 0.005;
  float inc = tick * scale;
  int t = (int)map(inc, 0, 1, 0, 255);
  // int sin = sinOsc(tick % 255);
  int noiseVal = inoise8(x * cellSize, y * cellSize, t);
  return color(noiseVal, 125, 255, 255);
}

// Sine wave from 0-255, given a 0-255 time value
int sinOsc(int t) {
  int deg = (int)map(t, 0, 255, 0, 360);
  float rad = radians(deg);
  float wave = sin(rad);
  return (int)map(wave, -1, 1, 0, 255);
}

int inoise8(int x) {
  return intervalToEight(noise(eightToInterval(x)));
}

int inoise8(int x, int y) {
  return intervalToEight(noise(eightToInterval(x), eightToInterval(y)));
}

int inoise8(int x, int y, int z) {
  return intervalToEight(noise(eightToInterval(x), eightToInterval(y), eightToInterval(z)));
}

float eightToInterval(int val) {
  return map(val, 0, 255, 0, 1);
}

// Maps a 0-1 value to 0-255
int intervalToEight(float val) {
  return (int)map(val, 0, 1, 0, 255);
}
