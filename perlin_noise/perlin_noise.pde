void setup() {
    size(800, 600);
}

void draw() {
    background(0);

    float z = mouseY;

    /*
    stroke(240);
    for (float x = 0; x <= width; x += 1) {
        line(x - 1, map(noise((x - 1)/100, y, z), 0, 1, height, 0),
                x, map(noise(x/100, y, z), 0, 1, height, 0));
    }
    */

    strokeWeight(3);
    for (float y = 0; y <= height; y += 4) {
        for (float x = 0; x <= width; x += 4) {
            stroke(map(noise(x, y, z), 0, 1, 128, 255));
            point(x, y);
        }
    }
}

