boolean looping = true;

void setup() {
  size(500, 500);
  background(0);
  noStroke();
  
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  for (int x = 0; x < width; x += 50) {
    for (int y = 0; y < height; y += 50) {
      fill(random(360), 50 + random(10), 50 + random(100)); 
      rect(x, y, 50, 50);
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