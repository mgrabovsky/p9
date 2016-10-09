void setup() {
  size(800, 800);
}

float gridStep   = 30;
float padding    = 40;
float hairLength = 20;
int mode = 0;

void draw() {
  background(230);

  strokeWeight(1);
  stroke(#457b9d);

  for (float x = padding; x <= width - padding; x += gridStep) {
    for (float y = padding; y <= height - padding; y += gridStep) {
      float d = dist(x, y, mouseX, mouseY);
      
      if (d == 0) {
        point(x, y);
        continue;
      }

      float alpha = 0;
      switch (mode) {
        case 0:
          // Hairs point towards mouse
          alpha = atan2(mouseY - y, mouseX - x);
          break;
        case 1:
          // Hairs point away from mouse
          alpha = atan2(y - mouseY, x - mouseX);
          break;
        case 2:
          // A kind of circular vector field -- counter-clockwise
          alpha = atan2(mouseX - x, y - mouseY);
          break;
        case 3:
          // Circular field -- clockwise
          alpha = atan2(x - mouseX, mouseY - y);
          break;
        case 4:
          // Hyperbolic along the diagonals, pointing towards
          alpha = atan2(mouseX - x, mouseY - y);
          break;
        case 5:
          // Hyperbolic along the diagonals, pointing away
          alpha = atan2(x - mouseX, y - mouseY);
          break;
        case 6:
          // Hyperbolic along the x-y axes, pointing towards
          alpha = atan2(y - mouseY, mouseX - x);
          break;
        case 7:
          // Hyperbolic along the x-y axes, pointing away
          alpha = atan2(mouseY - y, x - mouseX);
          break;
      }

      if (d < hairLength) {
        line(x, y, x + d * cos(alpha), y + d * sin(alpha));
      } else {
        line(x, y, x + hairLength * cos(alpha), y + hairLength * sin(alpha));
      }
    }
  }

  fill(120);
  textSize(12);
  text(String.format("%.1f FPS", frameRate), padding, height - 12);
  text(String.format("%d | %d %d", mode, mouseX, mouseY),
    width - padding - 65, height - 12);
}

void keyPressed() {
  if (key == ' ') {
    ++mode;
    mode %= 8;
  }
}