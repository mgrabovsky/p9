color[] colorScheme = { #2b4162, #385f71, #f5f0f6, #d7b377, #8f754f };
//color[] colorScheme = { #2d728f, #3b8ea5, #f5ee9e, #f49e4c, #ab3428 };

boolean looping = true;

color randomColor() {
  return colorScheme[int(random(colorScheme.length))];
}

void setup() {
  size(600, 600);
  frameRate(10);
  background(255);
  noStroke();

  colorMode(HSB, 360, 100, 100);
}

void draw() {
  for (int x = 50; x < width - 50; x += 50) {
    for (int y = 50; y < height - 50; y += 50) {
      if (x > width/2 - 100 && x < width/2 + 100 &&
          y > height/2 - 100 && y < height/2 + 100)
      {
        continue;
      }
      //fill(random(360), 50 + random(10), 50 + random(100));
      fill(randomColor());
      rect(x, y, 50, 50);
    }
  }
}

void keyPressed() {
  if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  }
}