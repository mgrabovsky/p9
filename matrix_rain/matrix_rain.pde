float mutationRate = 0.05;
float fontSize = 12;
int tailSize = 30;
float columnSpacing = 8;

PFont font;
int columnCount, columnHeight;
Column[] cols;
boolean looping = true;

class Column {
  ArrayList letters;
  int bottomPos;
  float size;
  color col;

  Column(int count, int startPos, color initialColor) {
    assert(startPos < count);
    bottomPos = startPos;
    col = initialColor;

    letters = new ArrayList(count);

    for (int i = 0; i < count; ++i) {
      letters.add(randomChar());
    }
  }

  private void mutate() {
    for (int i = 0; i < letters.size(); ++i) {
      if (random(1) < mutationRate) {
        letters.set(i, randomChar());
      }
    }
  }

  private void reset() {
    float oldHue = hue(col),
          dhue = random(-10, 10);

    if (dhue + oldHue > 255 || dhue + oldHue < 0) {
      dhue *= 1;
    }

    colorMode(HSB);
    col = color(oldHue + dhue, saturation(col), brightness(col));
    colorMode(RGB);

    bottomPos = 0;
  }

  void step() {
    bottomPos += 1;
    if (bottomPos == letters.size()) {
      reset();
    } else {
      mutate();
    }
  }

  void draw() {
    for (int i = 0; i < letters.size(); ++i) {
      if (i > bottomPos || bottomPos - i > tailSize) {
        continue;
      }

      if (bottomPos - i >= tailSize - 8) {
        float x = norm(bottomPos - i, tailSize - 8, tailSize);
        fill(lerpColor(col, #000000, x));
      } else if (bottomPos - i > 5) {
        fill(lerpColor(col, #000000, 0.3 * noise(i)));
      } else {
        fill(lerpColor(#efefef, col, (float)(bottomPos - i) / 5));
      }

      text((char)letters.get(i), 0, i * fontSize);
    }
  }
}

char randomChar() {
  //int c = int(random(0x21, 0x3f00));
  int c = int(random(0x3000, 0x3500));

  if (c >= 0x7f && c <= 0xa0) {
    c += 0x22;
  }

  return (char)c;
}

void setup() {
  size(900, 600);
  //fullScreen();
  frameRate(20);

  //font = createFont("Courier New Bold", fontSize);
  font = createFont("Code2000", fontSize);
  textFont(font, fontSize);

  columnCount  = int(width / (fontSize + columnSpacing));
  columnHeight = int(height / fontSize + tailSize);

  cols = new Column[columnCount];
  for (int i = 0; i < columnCount; ++i) {
    cols[i] = new Column(columnHeight, int(random(columnHeight)), #14b43c);
  }
}

void draw() {
  background(0);

  translate(columnSpacing, 0);
  for (Column col : cols) {
    col.draw();
    col.step();
    translate(fontSize + columnSpacing, 0);
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-###.png");
  } else if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  } else if (key == 'q') {
    exit();
  }
}

/* vim: set et sw=2 cindent: */
