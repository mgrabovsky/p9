float noiseSpread = 20;

void setup() {
  size(900, 900);
  frameRate(30);

  colorMode(HSB, 100, 100, 100);
  background(98);
}

void draw() {
  float angle = atan2(mouseX - pmouseX, mouseY - pmouseY);
  float ds = dist(mouseX, mouseY, pmouseX, pmouseY);

  strokeWeight(map(ds, 0, 100, 1, 20));
  stroke(color(map(angle, -PI, PI, 0, 100), 50, 85), 80);

  for (int i = 0; i < 5; ++i) {
    point(mouseX + random(noiseSpread), mouseY + random(noiseSpread));
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == 'c') {
    background(98);
  }
}

void mouseWheel(MouseEvent event) {
  float d = event.getCount();

  noiseSpread = constrain(noiseSpread - 5 * d, 0, 400);
}