float noiseSpread = 20;

void setup() {
  size(900, 900);

  colorMode(HSB, 100, 100, 100);
  background(98);
}

void draw() {
  float angle = atan2(mouseX - pmouseX, mouseY - pmouseY);
  float ds = dist(mouseX, mouseY, pmouseX, pmouseY);

  translate(mouseX, mouseY);
  rotate(-angle);

  strokeWeight(2);
  stroke(color(map(angle, -PI, PI, 0, 100), 50, 85), 80);
  line(-ds, 0, ds, 0);
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