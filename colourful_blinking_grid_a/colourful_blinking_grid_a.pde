boolean looping = true;

void circle(float x, float y, float r) {
  ellipse(x, y, r, r);
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

  for (int x = 20; x < width; x += 20) {
    for (int y = 20; y < height; y += 20) {
      fill(90 + random(150), 50 + random(60), 70 + random(10)); 
      circle(x, y, 5 + random(10));
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