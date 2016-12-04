import java.util.Calendar;

float padding = 100;
float gridStep = 20;
boolean showGrid = true;

ArrayList lines = new ArrayList();
boolean dragging = false;
float startX, startY, endX, endY;

float snapToGrid(float x) {
    return gridStep * round(x / gridStep);
}

void setup() {
    size(600, 600);
}

void draw() {
    background(255);
 
    if (showGrid) {
        noFill();
        strokeWeight(1);
        stroke(210);
        for (float y = padding; y <= height - padding; y += gridStep) {
            for (float x = padding; x <= width - padding; x += gridStep) {
                ellipse(x, y, 8, 8);
            }
        }
    }

    strokeWeight(8);
    strokeCap(ROUND);

    if (dragging) {
        stroke(0, 120);
        line(startX, startY, endX, endY);
    }

    stroke(0);
    for (Object coords : lines) {
        float[] c = (float[])coords;
        line(c[0], c[1], c[2], c[3]);
    }
}

void mousePressed() {
    dragging = true;
    startX = endX = snapToGrid(mouseX);
    startY = endY = snapToGrid(mouseY);
}

void mouseReleased() {
    dragging = false;
    lines.add(new float[]{ startX, startY, endX, endY });
}

void mouseDragged() {
    endX = snapToGrid(mouseX);
    endY = snapToGrid(mouseY);
}

void keyPressed() {
    if (key == 'g') {
        showGrid = !showGrid;
    } else if (key == 'c') {
        lines.clear();
    } else if (key == 'u') {
        if (!lines.isEmpty()) {
            lines.remove(lines.size() - 1);
        }
    } else if (key == 's') {
        saveFrame(timestamp() + "_##.png");
    } else if (key == 'q') {
        exit();
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

/* vim: set et sw=4 sts=4 ai cin: */