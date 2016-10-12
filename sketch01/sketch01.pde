int NPOINTS = 16;
boolean looping = true;

void circle(float x, float y, float r) {
    ellipse(x, y, r, r);
}

void clearBg() {
    background(340);
}

void setup() {
    size(600, 600);

    frameRate(10);
    colorMode(HSB, 360, 100, 100);
    clearBg();
}

float h = 190;

void draw() {
    clearBg();

    h += random(-9, 9);
    h %= 360;
    fill(h, 40 + random(10), 60 + random(10));
    noStroke();
    circle(width/2, height/2, 80);

    ArrayList<PVector> points = new ArrayList<PVector>();

    for (int i = 0; i < NPOINTS; ++i) {
        float r = random(60, 120);
        float arg = i * PI / (NPOINTS / 2);
        float x = width/2 + r * cos(arg);
        float y = height/2 + r * sin(arg);

        points.add(new PVector(x, y));
    }

    stroke(128);
    strokeWeight(1);
    for (int i = 0; i < NPOINTS; ++i) {
        float arg = i * PI / (NPOINTS / 2);
        float x0 = width/2 + 40 * cos(arg);
        float y0 = height/2 + 40 * sin(arg);

        line(points.get(i).x, points.get(i).y,
                points.get((i+1)%NPOINTS).x, points.get((i+1)%NPOINTS).y);
        line(x0, y0, points.get(i).x, points.get(i).y);
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
