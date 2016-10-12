boolean looping = true;

class Boid {
    float x, y, dir;

    Boid(float x, float y, float dir) {
        this.x = x;
        this.y = y;
        this.dir = dir;
    }
}

int boidCount = 150;
Boid[] boids;
PShape arrowhead;

void setup() {
    size(900, 600);
    //frameRate(20);
    colorMode(HSB, 360, 100, 100);

    boids = new Boid[boidCount];

    for (int i = 0; i < boidCount; ++i) {
        boids[i] = new Boid(random(width), random(height), random(TWO_PI));
    }

    arrowhead = createShape();
    arrowhead.beginShape();
    arrowhead.noStroke();
    arrowhead.vertex(-6, 4);
    arrowhead.vertex(6, 0);
    arrowhead.vertex(-6, -4);
    arrowhead.vertex(-2, 0);
    arrowhead.endShape(CLOSE);
    arrowhead.setFill(color(0));
}

void randomizeDirs() {
    for (int i = 0; i < boidCount; ++i) {
        boids[i].dir = random(TWO_PI);
    }
}

void drawArrow(Boid b, color col) {
    arrowhead.rotate(b.dir);
    arrowhead.setFill(col);
    shape(arrowhead, b.x, b.y);
    arrowhead.resetMatrix();
}

void draw() {
    background(320);
    noStroke();

    for (int i = 0; i < boidCount; ++i) {
        drawArrow(boids[i], color(360 * boids[i].dir / TWO_PI, 60, 70));
    }

    step();
}

void step() {
    // Calculate average boid direction in the flock
    float[] avgAngle = { 0, 0 };
    float avgDir = 0;

    for (int i = 0; i < boidCount; ++i) {
        float d = boids[i].dir;
        avgAngle[0] += cos(d);
        avgAngle[1] += sin(d);
    }

    avgDir = atan2(avgAngle[1], avgAngle[0]);

    for (int i = 0; i < boidCount; ++i) {
        int friendCount = 0;
        float[] friendsCentroid = { 0, 0 };

        // Move the boid in the direction of its flight
        boids[i].x += 0.5 * cos(boids[i].dir);
        boids[i].y += 0.5 * sin(boids[i].dir);

        // Toroidal topology
        if (boids[i].x < 0 || boids[i].x > width) {
            boids[i].x = width - boids[i].x;
        }
        if (boids[i].y < 0 || boids[i].y > height) {
            boids[i].y = height - boids[i].y;
        }

        // Avoid boids that are too close
        for (int j = 0; j < boidCount; ++j) {
            if (i == j) continue;

            float d = dist(boids[i].x, boids[i].y, boids[j].x, boids[j].y);
            // Count friends and compute their centroid
            if (d <= 200) {
                ++friendCount;
                friendsCentroid[0] += boids[j].x;
                friendsCentroid[1] += boids[j].y;
            }

            // Avoid boids that are to close
            if (d <= 30) {
                float r = sq(1 - norm(d, 0, 30));
                float alpha = atan2(boids[j].y - boids[i].y, boids[j].x - boids[i].x);
                boids[i].dir += TWO_PI + r * (PI - alpha) * 0.05;
                boids[i].dir %= TWO_PI;
            }
        }

        // Move closer to friends
        if (friendCount > 0) {
            friendsCentroid[0] /= friendCount;
            friendsCentroid[1] /= friendCount;

            float d = norm(dist(boids[i].x, boids[i].y, friendsCentroid[0], friendsCentroid[1]), 0, 200);
            if (d > 0) {
                float alpha = atan2(friendsCentroid[1] - boids[i].y, friendsCentroid[0] - boids[i].x);
                boids[i].dir += TWO_PI + alpha * 0.01;
                boids[i].dir %= TWO_PI;
            }
        }

        // Rotate the boid closer to the average direction
        boids[i].dir += (avgDir - boids[i].dir) * 0.01;
    }
}

void keyPressed() {
    if (key == 'r') {
        randomizeDirs();
    } else if (key == 's') {
        saveFrame("frame-####.png");
    } else if (key == ' ') {
        if (looping) noLoop(); else loop();
        looping = !looping;
    } else if (key == 'q') {
        exit();
    }
}

/* vim: set et sw=4 sts=4 ai cin: */
