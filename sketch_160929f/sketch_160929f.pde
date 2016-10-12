boolean looping = true;

PVector randomVector(float xLow, float xHigh, float yLow, float yHigh) {
  PVector v = new PVector(random(xLow, xHigh), random(yLow, yHigh));
  return v;
}

Triangle randomTriangle(float x, float y, float maxSize) {
  float r = maxSize / 2;
  PVector v1 = randomVector(x - r, x + r, y - r, y + r);
  PVector v2 = randomVector(x - r, x + r, y - r, y + r);
  PVector v3 = randomVector(x - r, x + r, y - r, y + r);

  Triangle t = new Triangle(v1, v2, v3);
  
  return t;
}

void clearBg() {
  colorMode(RGB, 255);
  background(240);
  colorMode(HSB, 360, 100, 100);
}

void setup() {
  size(800, 800);

  clearBg();
  noStroke();

  frameRate(10);
}

void draw() {
  clearBg();

  strokeWeight(2);
  noFill();
  for (int x = 50; x < width; x += 50) {
    for (int y = 50; y < height; y += 50) {
      stroke(180 + random(120), 60 + random(40), 80 + random(10)); 
      Triangle t = randomTriangle(x + random(10), y + random(10), 60);
      t.draw();
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  }
}