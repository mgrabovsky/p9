float weight = 2;
int opacity = 50;
boolean connect = false;

boolean drawing = false;

void setup() {
  size(800, 800);

  colorMode(HSB, 100, 100, 100, 100);
  background(98);
}

void draw() {
  if (drawing) {
    float angle = atan2(mouseX - pmouseX, mouseY - pmouseY);
    float ds = dist(mouseX, mouseY, pmouseX, pmouseY);

    if (connect) {
      strokeWeight(1);
      stroke(0, 10);
      line(pmouseX, pmouseY, mouseX, mouseY);
    }

    translate(mouseX, mouseY);
    rotate(-angle);

    strokeWeight(weight);
    stroke(color(map(angle, -PI, PI, 0, 100), 50, 85), opacity);
    line(-ds, 0, ds, 0);
  }
}

void keyPressed() {
  if (key == '+') {
    opacity = min(opacity + 5, 100);
  } else if (key == '*') {
    connect = !connect;
  }  else if (key == '-') {
    opacity = max(opacity - 5, 0);
  } else if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == 'c') {
    background(98);
  }
}

void mousePressed() { drawing = true; }
void mouseReleased() { drawing = false; }

void mouseWheel(MouseEvent event) {
  float d = event.getCount();

  weight = constrain(weight - d, 1, 10);
}