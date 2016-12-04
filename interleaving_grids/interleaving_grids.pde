float padding = 40;

void setup() {
  //fullScreen();
  size(1280, 720);

  frameRate(30);

  background(#22223b);
  noStroke();
}

void overlayBg() {
  blendMode(DARKEST);
  fill(#22223b, 5);
  rect(0, 0, width, height);
  blendMode(BLEND);
}

void draw() {
  int count = int(map(mouseX, 0, width, 2, 50));
  float size = map(mouseY, height, 0, 0, 20);

  float xIncr = (width - 2*padding) / count,
        yIncr = (height - 2*padding) / count;

  overlayBg();

  fill(#f2e9e4);
  for (float x = padding; x <= width - padding; x += xIncr) {
    for (float y = padding; y <= height - padding; y += yIncr) {
      ellipse(x, y, size, size);
    }
  }
}

void keyPressed() {
  if (key == 'c') {
    background(#22223b);
  } else if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == 'q') {
    exit();
  }
}