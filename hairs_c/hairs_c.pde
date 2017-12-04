import java.util.Calendar;

float angle0 = 0;

void setup() {
    size(600, 600);
}

void draw() {
    background(230);

    stroke(200);
    line(0, height/2, width/2 - 40, height/2);
    line(width/2 + 40, height/2, width, height/2);
    line(width/2, 0, width/2, height/2 - 40);
    line(width/2, height/2 + 40, width/2, height);

    float x = width / 2,
          y = height / 2,
          angle = atan2(mouseY - y, mouseX - x),
          d = dist(x, y, mouseX, mouseY);   

    // More natural angle difference
    // TODO: Can this be done more elegantly?
    float dangle = angle0 - angle;
    if (dangle > PI) {
        dangle = TWO_PI - dangle;
    } else if (dangle < -PI) {
        dangle = TWO_PI + dangle;
    }
    angle0 -= 0.02 * dangle;

    stroke(#c94866);
    line(x, y, x + 40 * cos(angle0), y + 40 * sin(angle0));

    stroke(#457b9d);
    line(x, y, x + d * cos(angle), y + d * sin(angle));

    fill(80);
    textSize(14);
    text(String.format("α  %.0f°", 360 * angle / TWO_PI), 30, 44);
    text(String.format("α' %.0f°", 360 * angle0 / TWO_PI), 30, 65);
    text(String.format("Δα %.0f°", 360 * (angle0 - angle) / TWO_PI), 30, 86);
}

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
