int antCount      = 5;
int itersPerFrame = 20;

color[] colors  = { #cccccc, #9d9d9d, #666666, #434343 };
boolean looping = true;
int[][] ants;

void setup() {
  size(600, 600);
  background(#ffffff);

  ants = new int[antCount][3];
  for (int i = 0; i < antCount; ++i) {
    ants[i][0] = int(random(width));
    ants[i][1] = int(random(height));
  }
}

int[] step(int x, int y, int dir) {
  color c = get(x, y);

  if (c == #ffffff) {
    set(x, y, colors[0]);
    dir = (dir + 1) % 4;
  } else if (c == colors[0]) {
    set(x, y, colors[1]);
    dir = (dir + 1) % 4;
  } else if (c == colors[1]) {
    set(x, y, colors[2]);
    dir = (dir + 2) % 4;
  } else if (c == colors[2]) {
    set(x, y, colors[3]);
    dir = (dir + 3) % 4;
  } else if (c == colors[3]) {
    set(x, y, colors[0]);
    dir = (dir + 3) % 4;
  }

  switch (dir) {
  case 0:
    x = (x + 1) % width;
    break;
  case 1:
    y = (y + height - 1) % height;
    break;
  case 2:
    x = (x + width - 1) % width;
    break;
  case 3:
    y = (y + 1) % height;
    break;
  }

  return new int[]{ x, y, dir };
}

void draw() {
  for (int n = 0; n < itersPerFrame; ++n) {
    for (int i = 0; i < antCount; ++i) {
      ants[i] = step(ants[i][0], ants[i][1], ants[i][2]);
    }
  }
}

void keyPressed() {
  if (key == '+') {
    itersPerFrame += 5;
  } else if (key == '-') {
    itersPerFrame = max(itersPerFrame - 5, 0);
  } else if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  } else if (key == 's') {
    saveFrame("sframe-####.png");
  } else if (key == 'q') {
    exit();
  }
}