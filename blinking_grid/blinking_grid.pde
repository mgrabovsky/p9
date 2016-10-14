boolean looping = true;

// Redraw background with slight transparency -- fades old lines
void layBg() {
    fill(40, 120);
    noStroke();
    rect(0, 0, width, height);
}

void setup() {
    size(600, 600);
    frameRate(15);

    background(40);
}

void draw() {
    layBg();

    strokeWeight(4);
    stroke(200);
    for (int x = 80; x <= width - 80; x += 20) {
        for (int y = 80; y <= height - 80; y += 20) {
            if (random(10) < 1) {
                point(x, y);
            }
        }
    }
}

void keyPressed() {
    if (key == 's') {
        saveFrame("frame-####.png");
    } else if (key == ' ') {
        if (looping) noLoop(); else loop();
        looping = !looping;
    } else if (key == 'q') {
        exit();
    }
}

/* vim: set et sw=4 sts=4 ai cin: */
