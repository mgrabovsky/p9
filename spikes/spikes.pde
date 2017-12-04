import java.util.Calendar;

float noiseLevel = 1;
float cx, cy;

void setup() {
    fullScreen();
    //size(600, 600);
    background(40);

    cx = width / 2;
    cy = height / 2;
}

void draw() {
    drawSpike(cx + random(-200, 200), cy + random(-200, 200));

    // Move the center
    float dx = random(-10, 10),
          dy = random(-10, 10);

    if (cx + dx < 0 || cx + dx > width) {
        dx *= -1;
    }
    if (cy + dy < 0 || cy + dy > height) {
        dy *= -1;
    }

    cx += dx;
    cy += dy;
}

void drawSpike(float x, float y) {
    strokeWeight(1);
    stroke(random(20, 230), 70);
    line(cx, cy, x, y);
}

void mousePressed() {
    if (mouseButton == LEFT) {
        drawSpike(mouseX, mouseY);
    } else if (mouseButton == RIGHT) {
        cx = mouseX;
        cy = mouseY;
    }
}

void mouseDragged() {
    if (mouseButton == LEFT) {
        drawSpike(mouseX, mouseY);
    }
}

void mouseWheel(MouseEvent event) {
    noiseLevel = constrain(noiseLevel - event.getCount(), 0, 20);
    println(noiseLevel);
}

void keyPressed() {
    if (key == 'c') {
        background(40);
    } else if (key == 's') {
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
