void setup() {
  size(900, 900, P3D);
}

float a = 0;

void draw() {
  background(#393e41);

  lights();

/*
  noStroke();
  fill(30, 40);
  rect(0, 0, width, height);
*/

  noFill();
  stroke(#e2c044);
  translate(width/2, height/2);
  rotateX(a);
  rotateY(0.8 * a);
  box(200);
  
  translate(a * width/4, height/5);
  rotateX(PI - a);
  rotateY(PI + 0.2 * a);
  rotateZ(a);
  sphereDetail(10);
  sphere(80);

  a += 0.02;
}

void keyPressed() {
  if (key == 'q') {
    exit();
  }
}

void mouseWheel(MouseEvent event) {
  /*float d = event.getCount();
  fsize -= int(d);*/
}
