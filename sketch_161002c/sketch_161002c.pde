boolean looping;
float x, y;
float h;

void setup() {
  size(600, 600);
  //frameRate(20);
  colorMode(HSB, 360, 100, 100);
  background(60);

  x = width / 2;
  y = height / 2;
  h = 220;
}

void draw() {
  noStroke();

  float r = random(10, 50);
  h = (h + random(20) + 350) % 360;

  fill(h, 60 + random(30), 80 + random(15));
  ellipse(x, y, r, r);

  float dx = 30 - random(60);
  float dy = 30 - random(60);
  if (x + dx < 0 || x + dx > width) {
    dx *= -1;
  }
  if (y + dy < 0 || y + dy > height) {
    dy *= -1;
  }

  x += dx;
  y += dy;

  noFill();
  strokeWeight(12);
  stroke(360);
  triangle(width / 2 - 100, height / 2 + 80,
           width / 2 + 100, height / 2 + 80,
           width / 2,       height / 2 - 90);
  triangle(width / 2 - 100, height / 2 - 40,
           width / 2 + 100, height / 2 - 40,
           width / 2,       height / 2 + 130);
}

void keyPressed() {
  if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  } else if (key == 's') {
    saveFrame("sframe-####.png");
  }
}