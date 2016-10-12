boolean looping = true;

int n = 7;
int r = 50;
int shapes = 40;
//color[] colorScheme = { #f6f1d1, #cfd7c7, #70a9a1, #40798c };
//color[] colorScheme = { #272727, #d4aa7d, #efd09e, #d2d8b3, #90a9b7 };
color[] colorScheme = { #f2d7ee, #d3bcc0, #a5668b, #69306d, #0e103d };

void setup() {
  size(800, 800);
  frameRate(5);
}

void draw() {
  background(#f9e5db);

  PShape polygon = createShape();
  polygon.beginShape();
  polygon.noStroke();
  for (int i = 0; i < n; ++i) {
    polygon.vertex(r * cos(i * TWO_PI / n), r * sin(i * TWO_PI / n));
  }
  polygon.endShape(CLOSE);

  for (int i = 0; i < shapes; ++i) {
    polygon.setFill(colorScheme[int(random(colorScheme.length))]);
    polygon.rotate(random(TWO_PI));
    polygon.scale(random(1));
    shape(polygon, random(r, width - r), random(r, height - r));
    polygon.resetMatrix();
  }

  r = int(100 * mouseY / height);
  n = max(3, int(9 * mouseX / width));
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == ' ') {
    if (looping) noLoop(); 
    else loop();
    looping = !looping;
  }
}