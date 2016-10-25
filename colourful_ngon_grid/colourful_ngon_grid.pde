import processing.pdf.*;

boolean looping = true;
//color[] colors = { #ffaf87, #ff8e72, #ed6a5e, #4ce0b3, #377771 };
//color[] colors = { #809bce, #95b8d1, #b8e0d2, #d6eadf, #eac4d5 };
//color[] colors = { #3a405a, #aec5eb, #f9dec9, #e9afa3, #685044 };
//color[] colors = { #36213e, #554971, #63768d, #8ac6d0, #b8f3ff };
//color[] colors = { #676a6c, #4c5c68, #57a6ba, #c5c3c6, #dcdcdd };
//color[] colors = { #472d30, #723d46, #e26d5c, #ffe1a8, #c9cba3 };
//color[] colors = { #1d3557, #457b9d, #a8dadc, #f1faee, #e63946 };
//color[] colors = { #6d6465, #86c1ba, #9ae9ef, #f23f0e, #ff6528 };
//color[] colors = { #0d1321, #1d2d44, #3e5c76, #748cab, #f0ebd8 };
color[] colors = { #254e70, #37718e, #8ee3ef, #aef3e7, #c33c54 };
float unit = 36;

float ux = unit / sqrt(3);
float maxDist;
boolean recordPDF = false;

PShape Hexagon;

color randomColor() {
  return colors[int(random(colors.length))];
}

void setup() {
  //size(800, 800);
  fullScreen();
  frameRate(10);

  maxDist = sqrt(sq(width) + sq(height)) / 2;

  Hexagon = createShape();
  Hexagon.beginShape();
  Hexagon.noStroke();
  Hexagon.vertex(0, 1);
  Hexagon.vertex(sqrt(3)/2, .5);
  Hexagon.vertex(sqrt(3)/2, -.5);
  Hexagon.vertex(0, -1);
  Hexagon.vertex(-sqrt(3)/2, -.5);
  Hexagon.vertex(-sqrt(3)/2, .5);
  Hexagon.endShape(CLOSE);
}

void draw() {
  if (recordPDF) {
    beginRecord(PDF, "frame-####.pdf");
  }

  background(255);
  noStroke();
  Hexagon.scale(unit/2);

  int iter = 0;
  for (float y = 0; y < height + ux; y += unit*sqrt(2.2)/2, ++iter) {
    float x=0;
    if (iter % 2 == 0) {
      x = 0;
    } else {
      x = unit*sqrt(3)/4;
    }

    for (; x < width + ux; x += unit*sqrt(3)/2) {
      float d = map(max(200, dist(x, y, width/2, height/2)),
                  200,           maxDist,
                  colors.length, 0);

      /*
      fill(colors[int(random(max(0, d-2), d))]);
      triangle(x - ux, y, x + ux, y, x, y + unit);
      fill(colors[int(random(max(0, d-2), d))]);
      triangle(x + ux, y, x, y + unit, x + 2*ux, y + unit);
      */

      color col = colors[int(random(max(0, d-2), d))];
      Hexagon.setFill(col);
      shape(Hexagon, x, y);
    }
  }

  Hexagon.resetMatrix();

  if (recordPDF) {
    endRecord();
    recordPDF = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  } else if (key == 's') {
    saveFrame("frame-####.png");
  } else if (key == 'p') {
    recordPDF = true;
  } else if (key == 'q') {
    exit();
  }
}
