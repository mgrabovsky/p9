boolean looping = true;
int x0, y0, dir0,
    x1, y1, dir1,
    x2, y2, dir2,
    x3, y3, dir3;
int iters = 20;

void setup() {
  size(600, 600);
  background(#ffffff);

  x0 = width / 2;
  y0 = height / 2;
  dir0 = 0;

  x1 = width / 2 + 100;
  y1 = height / 2;
  dir1 = 0;

  x2 = width / 2 + 50;
  y2 = height / 2 + 100;
  dir2 = 0;

  x3 = width / 2 + 100;
  y3 = height / 2 + 200;
  dir3 = 2;
}

int[] step(int x, int y, int dir) {
  if (get(x, y) == #ffffff) {
    set(x, y, #000000);
    dir = (dir + 1) % 4;
  } else {
    set(x, y, #ffffff);
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

  int[] ret = { x, y, dir };
  return ret;
}

void draw() {
  int[] st0 = { x0, y0, dir0 };
  int[] st1 = { x1, y1, dir1 };
  int[] st2 = { x2, y2, dir2 };
  int[] st3 = { x3, y3, dir3 };

  for (int n = 0; n < iters; ++n) {
    st0 = step(st0[0], st0[1], st0[2]);
    st1 = step(st1[0], st1[1], st1[2]);
    st2 = step(st2[0], st2[1], st2[2]);
    st3 = step(st3[0], st3[1], st3[2]);
  }

  x0 = st0[0];
  y0 = st0[1];
  dir0 = st0[2];

  x1 = st1[0];
  y1 = st1[1];
  dir1 = st1[2];

  x2 = st2[0];
  y2 = st2[1];
  dir2 = st2[2];

  x3 = st3[0];
  y3 = st3[1];
  dir3 = st3[2];
}

void keyPressed() {
  if (key == '+') {
    iters += 5;
  } else if (key == '-') {
    iters = max(iters - 5, 0);
  } else if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  } else if (key == 's') {
    saveFrame("sframe-####.png");
  }
}