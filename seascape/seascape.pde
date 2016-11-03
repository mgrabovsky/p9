float[][] points;
float xIncr, yIncr;
int horizontalCount = 40, verticalCount = 20;
float r = 0.5;

void setup() {
  size(900, 900);

  yIncr = height / verticalCount;
  xIncr = width / horizontalCount + 1;  

  points = new float[verticalCount][horizontalCount];
  for (int i = 0; i < verticalCount; ++i) {
    for (int j = 0; j < horizontalCount; ++j) {
      points[i][j] = i * yIncr + random(-7, 7);
    }
  }
}

void draw() {
  background(#ffcc00);

  noStroke();
  for (int i = 0; i < verticalCount; ++i) {
    fill(lerpColor(#3451ba, #a4e8e0, (float)i / verticalCount));
    beginShape();
    vertex(0, height);
    for (int j = 0; j < horizontalCount; ++j) {
      vertex(j * xIncr, 30 + points[i][j]);
    }
    vertex(width, height);
    endShape(CLOSE);
  }

  for (int i = 0; i < verticalCount; ++i) {
    for (int j = 0; j < horizontalCount; ++j) {
      points[i][j] += random(-r, r);
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-####.png");
  }
}