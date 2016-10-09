float padding    = 40;
float gridStep   = 30;
float hairLength = 20;
float senseRadius = 60;

int rows, cols;
float[][] angles;

void resetAngles() {
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      angles[i][j] = 0;
    }
  }
}

void setup() {
  size(800, 800);

  rows = int((height - 2*padding) / gridStep);
  cols = int((width - 2*padding) / gridStep);
  angles = new float[rows][cols];
}

void draw() {
  background(230);

  noFill();
  stroke(140);
  ellipse(mouseX, mouseY, 2*senseRadius, 2*senseRadius);

  strokeWeight(1);
  stroke(#457b9d);
  
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      float y = padding + i * gridStep;
      float x = padding + j * gridStep;
      
      strokeWeight(3);
      point(x, y); 
      strokeWeight(1);

      float d = dist(x, y, mouseX, mouseY);   

      if (d == 0) {
        point(x, y);
        continue;
      }

      float alpha = atan2(mouseY - y, mouseX - x);
      if (d < senseRadius) {
        angles[i][j] = alpha;
      } else {
        // FIXME: Weird behaviour when to the right of mouse
        angles[i][j] -= 0.02 * (angles[i][j] - alpha);
      }

      if (d < hairLength) {
        line(x, y, x + d * cos(angles[i][j]), y + d * sin(angles[i][j]));
      } else {
        // FIXME: Weird behaviour when to the right of mouse
        line(x, y, x + hairLength * cos(angles[i][j]),
              y + hairLength * sin(angles[i][j]));
      }
    }
  }

  fill(120);
  textSize(12);
  text(String.format("%.1f FPS", frameRate), padding, height - 12);
}

void keyPressed() {
  if (key == 'r') {
    resetAngles();
  } else if (key == 'q') {
    exit();
  }
}