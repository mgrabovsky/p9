float mutationRate = 0.1;
float fontSize = 14;
int tailSize = 25;

PFont font;
int columnCount, columnHeight;
Column[] cols;
boolean looping = true;

class Column {
  ArrayList letters;
  int bottomPos;
  float size;

  Column(int count, int startPos) {
    assert(startPos < count);
    bottomPos = startPos;

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

  void step() {
    bottomPos += 1;
    bottomPos %= letters.size();

    mutate();
  }

  void draw() {
    for (int i = 0; i < letters.size(); ++i) {
      if (i > bottomPos || bottomPos - i > tailSize) {
        continue;
      }

      if (bottomPos - i >= tailSize - 12) {
        float n = noise(i);
        float x = n * norm(bottomPos - i, tailSize - 12, tailSize);
        fill(lerpColor(#14b43c, #000000, x));
      } else {
        fill(lerpColor(#efefef, #14b43c, (float)(bottomPos - i) / 5));
      }

      text((char)letters.get(i), 0, i * fontSize);
    }
  }
}

char randomChar() {
  int c = int(random(0x21, 0x0300));

  if (c >= 0x7f && c <= 0xa0) {
    c += 0x22;
  }

  return (char)c;
}

void setup() {
  //size(900, 900);
  fullScreen();
  frameRate(20);

  font = createFont("Courier New Bold", fontSize);
  textFont(font, fontSize);

  columnCount  = int(width / fontSize);
  columnHeight = int(height / fontSize + tailSize);

  cols = new Column[columnCount];
  for (int i = 0; i < columnCount; ++i) {
    cols[i] = new Column(columnHeight, int(random(columnHeight)));
  }
}

void draw() {
  background(0);

  for (Column col : cols) {
    translate(fontSize, 0);
    col.draw();
    col.step();
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