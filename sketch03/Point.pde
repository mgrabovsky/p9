class Point {
    float x, y, size;
    float v, dir;

    Point(float x0, float y0, float size, float speed, float direction) {
        x = x0;
        y = y0;

        this.size = size;
        v = speed;
        dir = direction;
    }

    void tick() {
        float dx = v * cos(dir);
        float dy = v * sin(dir);

        x += dx;
        y += dy;

        // Wrap around borders
        if (x < 0 || x > width) {
            x = width - x;
        } 

        if (y < 0 || y > height) {
            y = height - y;
        }
    }

    void draw() {
        strokeWeight(size);
        point(x, y);
    }
}

/* vim: set et sw=4 sts=4 ai cin: */
