int horizontalCount = 20, verticalCount = 10;
float waveSpread = 40;
float paddingTop = 100;
float r = 0.5;

float[][] points;
float xStep, yStep;
float time = 0;
float dt = 0.005;

PShape bird;
boolean birdFlying = true;
float birdX, birdY, birdHeading;

void setup() {
  size(800, 800);

  yStep = (height - paddingTop) / verticalCount;
  xStep = width / horizontalCount;
  ++horizontalCount;

  points = new float[verticalCount][horizontalCount];

  bird = loadShape("seagull.svg");
}

void step() {
  // Animate waves
  for (int i = 0; i < verticalCount; ++i) {
    for (int j = 0; j < horizontalCount; ++j) {
      points[i][j] = noise(time + i, j);
    }
  }

  time += dt;

  // Animate bird
  if (birdFlying) {
    if (birdX < -40 || birdY < -100 || birdY > height) {
      birdFlying = false;
    }

    birdX -= cos(birdHeading);
    birdY += sin(birdHeading);
  } else if (random(1) < 0.01) {
    birdFlying = true;
    birdX = width;
    birdY = random(paddingTop, height - paddingTop);
    birdHeading = random(-PI/8, PI/8);
  }
}

void draw() {
  step();

  background(#f7da59);

  // Draw waves
  noStroke();
  for (int i = 0; i < verticalCount; ++i) {
    fill(lerpColor(#a4e8e0, #3451ba, (float)i / (verticalCount - 1)));

    beginShape();
    vertex(0, height);
    for (int j = 0; j < horizontalCount; ++j) {
      vertex(j * xStep, paddingTop + i * yStep + waveSpread * points[i][j]);
    }
    vertex(width, height);
    endShape(CLOSE);
  }

  // Draw bird
  if (birdFlying) {
    translate(birdX, birdY);
    scale(0.25);
    shape(bird, 0, 0);
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-####.png");
  }
}