PImage img;

void setup() {
  size(800, 1000);

  img = loadImage("sunflower.jpg");
  img.loadPixels();
}

void draw() {
  background(0);

  int w = img.width, h = img.height;
  float[] avgs = new float[3];

  strokeWeight(10);
  for (int x = 0; x < w; x += 10) {
    for (int y = 0; y < h; y += 10) {
      // Compute average colour
      for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 10; ++j) {
          color px = img.pixels[i + x + (y + j) * w];
          avgs[0] += red(px);
          avgs[1] += green(px);
          avgs[2] += blue(px);
        }
      }

      avgs[0] /= 100;
      avgs[1] /= 100;
      avgs[2] /= 100;
      stroke(avgs[0], avgs[1], avgs[2]);
      point(x + 5, y + 5);
    }
  }

  noLoop();
}