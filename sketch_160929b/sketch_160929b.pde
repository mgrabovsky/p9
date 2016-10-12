void setup() {
  size(900, 900);
  colorMode(HSB, 360, 100, 100);
  background(200, 60, 60);
}

void draw() {
  hue(frameCount/2);
  background((frameCount/2) % 360, 50, 80);
}