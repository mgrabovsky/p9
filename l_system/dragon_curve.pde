import java.util.Stack;

boolean looping = true;
float unit = 4;
float dangle = PI / 2;
float delta = 0.65; /* 0 < delta <= 1 */
float noise = 0.0;
int depth = 15;

String start = "FX";
HashMap<Character, String> rules = new HashMap<Character, String>();

class TurtleState {
  float x, y, angle;
  
  TurtleState(float x, float y, float angle) {
    this.x = x;
    this.y = y;
    this.angle = angle;
  }
}

void setup() {
  size(800, 800);
  frameRate(20);

  rules.put('X', "X+YF+");
  rules.put('Y', "-FX-Y");
}

void perform(String program, float x, float y, float angle) {
  performHelper(program, x, y, angle, 0);
}

TurtleState performHelper(String program, float x, float y, float angle, int d) {
  Stack<TurtleState> stateStack = new Stack<TurtleState>();

  for (char c : program.toCharArray()) {
    if (rules.containsKey(c) && d < depth) {
      TurtleState newState = performHelper(rules.get(c), x, y, angle, d + 1);
      x = newState.x;
      y = newState.y;
      angle = newState.angle;
      continue;
    }

    switch (c) {
    case 'F': {
      float alpha = angle - noise / 2 + random(noise);
      float x1 = x + unit * cos(alpha);
      float y1 = y + unit * sin(alpha);
      line(x, y, x1, y1);
      x = x1;
      y = y1;
      break; }
    case '|': {
      float alpha = angle - noise / 2 + random(noise);
      float x1 = x + unit * cos(alpha) * pow(delta, d);
      float y1 = y + unit * sin(alpha) * pow(delta, d);
      line(x, y, x1, y1);
      x = x1;
      y = y1;
      break; }
    case 'G': {
      float alpha = angle - noise / 2 + random(noise);
      x = x + unit * cos(alpha);
      x = y + unit * sin(alpha);
      break; }
    case '+':
      angle += dangle;
      break;
    case '-':
      angle -= dangle;
      break;
    case '[':
      stateStack.push(new TurtleState(x, y, angle));
      break;
    case ']':
      if (!stateStack.empty()) {
        TurtleState st = stateStack.pop();
        x = st.x;
        y = st.y;
        angle = st.angle;
      }
      break;
    }
  }
  
  TurtleState st = new TurtleState(x, y, angle);
  return st;
}

void draw() {
  background(255);

  strokeWeight(1);
  strokeCap(SQUARE);
  stroke(0, 128);

  //noise = (float)mouseX / width;
  //delta = (float)mouseY / height;
  perform(start, width / 2, height / 2, 0);

  noLoop();
}

void keyPressed() {
  if (key == ' ') {
    if (looping) noLoop(); else loop();
    looping = !looping;
  } else if (key == 's') {
    saveFrame("sframe-####.png");
  }
}