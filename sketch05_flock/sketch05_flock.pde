import java.util.Calendar;

int boidCount = 100;
float boidSpeed = 0.5;
float flockRadius = 120;
float personalSpaceRadius = 15;
float bunchingFactor = 0.008;
float repulsionFactor = 0.020;
float headingFactor = 0.01;
boolean allowBunching = true;
boolean avoidCrashing = true;

int debugId = 0;
boolean looping = true;
boolean movieCapture = false;
Boid[] boids;
PShape arrowhead;

class Boid {
    float x, y, heading;

    Boid(float x, float y, float heading) {
        this.x = x;
        this.y = y;
        this.heading = heading;
    }

    void draw() {
        arrowhead.rotate(heading);
        arrowhead.setFill(angleToColor(heading));
        arrowhead.scale(1.2);
        shape(arrowhead, x, y);
        arrowhead.resetMatrix();
    }
}

void randomizeHeadings() {
    for (int i = 0; i < boidCount; ++i) {
        boids[i].heading = random(TWO_PI);
    }
}

color angleToColor(float angle) {
    return color(100 * angle / TWO_PI, 55, 80);
}

void step() {
    for (int i = 0; i < boidCount; ++i) {
        float x = boids[i].x,
              y = boids[i].y,
              heading = boids[i].heading;

        int friendCount = 0;
        float[] friendsCentroid = { 0, 0 };
        float[] avgDirection = { 0, 0 };
        float angleDelta = 0;

        for (int j = 0; j < boidCount; ++j) {
            if (i == j) continue;

            float d = dist(x, y, boids[j].x, boids[j].y);
            // Count friends in flock and compute their centroid and average heading
            if (d <= flockRadius) {
                ++friendCount;
                friendsCentroid[0] += boids[j].x;
                friendsCentroid[1] += boids[j].y;
                avgDirection[0] += cos(boids[j].heading);
                avgDirection[1] += sin(boids[j].heading);
            }

            // Avoid boids that are too close
            if (avoidCrashing && d <= personalSpaceRadius) {
                float r = norm(d, 0, personalSpaceRadius);
                float alpha = atan2(boids[j].y - y, boids[j].x - x);
                angleDelta += (1 - r) * (heading - alpha) * repulsionFactor;
            }
        }

        if (friendCount > 0) {
            friendsCentroid[0] /= friendCount;
            friendsCentroid[1] /= friendCount;

            // Move closer to friends
            if (allowBunching) {
                float d = norm(dist(x, y, friendsCentroid[0], friendsCentroid[1]),
                                0, flockRadius);
                if (d > 0) {
                    float alpha = atan2(friendsCentroid[1] - y,
                                        friendsCentroid[0] - x);
                    angleDelta += (1 - d) * (alpha - heading) * bunchingFactor;
                }
            }

            // Rotate the boid closer to the average direction
            float avgHeading = atan2(avgDirection[1], avgDirection[0]);
            angleDelta += (avgHeading - heading) * headingFactor;

            boids[i].heading = (heading + angleDelta + TWO_PI) % TWO_PI;
        }

        // Move the boid a step in the direction of its flight
        x += boidSpeed * cos(heading);
        y += boidSpeed * sin(heading);

        // Toroidal topology
        if (x < 0 || x > width) {
            x = width - x;
        }
        if (y < 0 || y > height) {
            y = height - y;
        }

        boids[i].x = x;
        boids[i].y = y;
    }
}

void setup() {
    size(800, 600);
    //fullScreen();
    //frameRate(20);
    colorMode(HSB, 100, 100, 100);

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

void draw() {
    background(95);
    noStroke();

    noFill();
    stroke(80);
    ellipse(boids[debugId].x, boids[debugId].y, 2*flockRadius, 2*flockRadius);
    stroke(60);
    ellipse(boids[debugId].x, boids[debugId].y, 2*personalSpaceRadius, 2*personalSpaceRadius);

    for (int i = 0; i < boidCount; ++i) {
        boids[i].draw();
    }

    step();

    if (movieCapture) {
      saveFrame("frames/flock-####.png");
    }
}

void keyPressed() {
    if (key == 'r') {
        randomizeHeadings();
    } else if (key == '1') {
        allowBunching = !allowBunching;
    } else if (key == '2') {
        avoidCrashing = !avoidCrashing;
    } else if (key == 'n') {
        debugId = (debugId + 1) % boidCount;
    } else if (key == 'p') {
        debugId = (debugId + boidCount - 1) % boidCount;
    } else if (key == 's') {
        saveFrame(timestamp()+"_##.png");
    } else if (key == 'm') {
      movieCapture = !movieCapture;
    } else if (key == ' ') {
        if (looping) noLoop(); else loop();
        looping = !looping;
    } else if (key == 'q') {
        exit();
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

/* vim: set et sw=4 sts=4 ai cin: */
