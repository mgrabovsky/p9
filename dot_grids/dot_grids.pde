import java.util.Calendar;

float cx, cy;

void setup() {
    fullScreen();

    cx = width / 2;
    cy = height / 2;
}

void draw() {
    background(240);
    noStroke();

    fill(0, 50);
    for (int i = 0; i < 20; ++i) {
        for (int j = 0; j < 10; ++j) {
            float x = 150 + 50 * i,
                  y = 150 + 50 * j;

            ellipse(x, y, 30, 30);
        }
    }

    fill(#e01825, 70);
    for (int i = 0; i < 20; ++i) {
        for (int j = 0; j < 10; ++j) {
            float x = 130 + 52 * i,
                  y = 140 + 52.5 * j;

            ellipse(x, y, 30, 30);
        }
    }
}

/*
void mouseWheel(MouseEvent event) {
    noiseLevel = constrain(noiseLevel - event.getCount(), 0, 20);
    println(noiseLevel);
}
*/

void keyPressed() {
    if (key == 's') {
        saveFrame(timestamp()+"_##.png");
    } else if (key == 'q') {
        exit();
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

/* vim: set et sw=4 sts=4 ai cin: */
