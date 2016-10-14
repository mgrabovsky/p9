//color[] colorScheme = { #2b4162, #385f71, #f5f0f6, #d7b377, #8f754f };
color[] colorScheme = { #2d728f, #3b8ea5, #f5ee9e, #f49e4c, #ab3428 };

boolean looping = true;

color randomColor() {
  return colorScheme[int(random(colorScheme.length))];
}

// Redraw background with slight transparency -- fades old lines
void layBg() {
    blendMode(DARKEST);
    fill(40, 80);
    noStroke();
    rect(0, 0, width, height);
    blendMode(BLEND);
}

void setup() {
    size(600, 600);
    frameRate(15);

    background(40);
}

void draw() {
    layBg();

    strokeWeight(8);
    if (frameCount % 4 == 0) {
        for (int x = 80; x <= width - 80; x += 20) {
            for (int y = 80; y <= height - 80; y += 20) {
                if (random(10) < 1) {
                    stroke(randomColor());
                    point(x, y);
                }
            }
        }
    }
}

void keyPressed() {
    if (key == 'c') {
        background(40);
    } else if (key == 's') {
        saveFrame("frame-####.png");
    } else if (key == ' ') {
        if (looping) noLoop(); else loop();
        looping = !looping;
    } else if (key == 'q') {
        exit();
    }
}

/* vim: set et sw=4 sts=4 ai cin: */