PFont font;
StringBuilder textContents = new StringBuilder();
int fsize = 20;

void setup() {
  size(800, 600);

  //printArray(PFont.list());
  //font = createFont("Franklin Gothic Demi Cond", 32);
  font = createFont("Palatino Linotype Italic", 40, true);
}

void draw() {
  background(#393e41);

  fill(#e2c044);
  textFont(font);
  textSize(fsize);
  textLeading(1.4 * fsize);
  textAlign(CENTER);
  text(textContents.toString(), width/4, 40, width/2, height);

}

void keyPressed() {
  if (keyCode == BACKSPACE) {
    if(textContents.length() > 0) {
      textContents.deleteCharAt(textContents.length() - 1);
    }
  } else {
    textContents.append(key);
  }
}

void mouseWheel(MouseEvent event) {
  float d = event.getCount();
  fsize -= int(d);
}
