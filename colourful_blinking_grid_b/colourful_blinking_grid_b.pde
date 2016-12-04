boolean looping = true;

float time = 0;

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

  frameRate(30);
}

void draw() {
  clearBg();

  float hueBase = 360 * mouseX / width;
  float sizeVar = 80 * mouseY / height;

  for (int x = 40; x <= width - 40; x += 40) {
    for (int y = 40; y <= height - 40; y += 40) {
      fill((hueBase + 120 * noise(time, x/40, y/40)) % 360,
            50 + 40 * noise(time, x/40, y/40),
            70 + 20 * noise(time, x/40, y/40),
            120);
      circle(x, y, 4 + sizeVar * noise(time + x / 20, y));
    }
  }

  fill(0, 80);
  noStroke();
  ellipse(mouseX, mouseY, 20, 20);

  time += 0.01;
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  }
}