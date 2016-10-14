boolean looping = true;
float x0 = 100, y0 = 100;
float h = 0;

void setup() {
    size(600, 600);

    colorMode(HSB, 360, 100, 100);
    background(340);
}

void draw() {
    // Redraw background with slight transparency -- fades old lines
    noStroke();
    fill(340, 5);
    blendMode(LIGHTEST);
    rect(0, 0, width, height);
    blendMode(BLEND);

    // New direction differentials
    float dx = 20 - random(40);
    float dy = 20 - random(40);

    float x1 = x0 + dx;
    float y1 = y0 + dy;

    // Bounce off borders
    if (x1 < 0 || x1 > width)
        x1 = x0 - dx;
    if (y1 < 0 || y1 > height)
        y1 = y0 - dy;

    // Roll hue
    h += 5 * dist(x0, y0, x1, y1) / (20 * sqrt(2));
    h %= 360;

    // Draw the coloured trace
    strokeWeight(1);
    stroke(h, 60, 80);
    line(x0, y0, x1, y1);

    // Draw endpoints
    strokeWeight(4);
    point(x1, y1);

    x0 = x1;
    y0 = y1;
}

void keyPressed() {
    if (key == 's') {
        saveFrame("frame-####.png");
    } else if (key == ' ') {
        if (looping) noLoop(); else loop();
        looping = !looping;
    } else if (key == 'q') {
        exit();
    } else if (key == 'c') {
        noStroke();
        fill(340);
        rect(0, 0, width, height);
    }
}

/* vim: set et sw=4 sts=4 ai cin: */
