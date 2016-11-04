float spread = 20;
int opacity = 50;

boolean drawing = false;

void setup() {
  size(800, 800);
  frameRate(30);

  colorMode(HSB, 100, 100, 100, 100);
  background(98);
}

void draw() {
  if (drawing) {
    float angle = atan2(mouseX - pmouseX, mouseY - pmouseY);
    float ds = dist(mouseX, mouseY, pmouseX, pmouseY);
  
    strokeWeight(map(ds, 0, 100, 1, 20));
    stroke(color(map(angle, -PI, PI, 0, 100), 50, 85), opacity);
  
    for (int i = 0; i < 5; ++i) {
      point(mouseX + random(-spread, spread),
            mouseY + random(-spread, spread));
    }
  }

  fill(98);
  noStroke();
  rect(12, 10, 70, 28);
  fill(40);
  text(String.format("opacity: %d\nspread: %.0f", opacity, spread), 12, 20);
}

void keyPressed() {
  if (key == '+') {
    opacity = min(opacity + 5, 100);
  } else if (key == '-') {
    opacity = max(opacity - 5, 0);
  } else if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == 'c') {
    background(98);
  } else if (key == 'q') {
    exit();
  }
}

void mousePressed() { drawing = true; }
void mouseReleased() { drawing = false; }

void mouseWheel(MouseEvent event) {
  float d = event.getCount();

  spread = constrain(spread - 5 * d, 0, 400);
}