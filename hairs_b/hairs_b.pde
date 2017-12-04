import java.util.Calendar;

float padding     = 40;
float gridStep    = 20;
float hairLength  = 15;
float senseRadius = 40;

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
        continue;
      }

      float alpha = atan2(mouseY - y, mouseX - x);
      if (d < senseRadius) {
        angles[i][j] = alpha;
      } else {
        float dangle = angles[i][j] - alpha;
        if (dangle > PI) {
            dangle = TWO_PI - dangle;
        } else if (dangle < -PI) {
            dangle = TWO_PI + dangle;
        }
        angles[i][j] -= 0.02 * dangle;
        angles[i][j] %= TWO_PI;
      }

      if (d < hairLength) {
        line(x, y, x + d * cos(angles[i][j]), y + d * sin(angles[i][j]));
      } else {
        line(x, y, x + hairLength * cos(angles[i][j]),
              y + hairLength * sin(angles[i][j]));
      }
    }
  }

  /*
  fill(120);
  textSize(12);
  text(String.format("%.1f FPS", frameRate), padding, height - 12);
  */
}

void keyPressed() {
    if (key == 'r') {
        resetAngles();
    } else if (key == 's') {
        saveFrame(timestamp()+"_##.png");
    } else if (key == 'q') {
        exit();
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

/* vim: set et sw=4 sts=4 ai cin: */
