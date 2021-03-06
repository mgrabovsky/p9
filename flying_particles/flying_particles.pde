boolean looping = true;
ArrayList<Point> points = new ArrayList<Point>();

color[] colorScheme = { #ef767a, #456990, #49dcb1, #eeb868 };

// Redraw background with slight transparency -- fades old lines
void layBg() {
    fill(40, 15);
    noStroke();
    blendMode(DARKEST);
    rect(0, 0, width, height);
    blendMode(BLEND);
}

void setup() {
    //size(600, 600);
    fullScreen();

    background(40);

    for (float x = 40; x <= width - 40; x += 26) {
        for (float y = 40; y <= height - 40; y += 26) {
            if (random(10) > 1) continue;

            float dir = round(random(0, 8)) * QUARTER_PI;
            color col = colorScheme[int(random(colorScheme.length))];
            points.add(new Point(x, y, random(2, 8), 1.0, dir, col));
        }
    }
}

void draw() {
    layBg();

    stroke(200);
    for (Point point : points) {
        point.tick();
        point.draw();
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