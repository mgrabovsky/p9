import java.util.Calendar;
import java.util.Locale;
import processing.pdf.*;

// Tweak these and see what happens

// -- Structure
int maxNodes      = 500;
float hoodDensity = 0.6;
float hoodRadius  = 150;

// -- Behavior
float infectionRate = 0.005;
float recoveryRate  = 0.008;

// -- Appearance
float nodeSize   = 20;
float edgeWeight = 2;

color backgroundColor  = color(30);
color activeEdgeColor  = color(255, 50);
color passiveEdgeColor = color(255, 20);
color newEdgeColor     = color(255, 90);
color susceptibleColor = #61e8cd;
color infectiousColor  = #e8635c;
color recoveredColor   = color(50);

float animationSpeed = 0.06;
float animationScale = 0.5;

/* `~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~ */

boolean editing = true;
boolean recordingMovie = false;
boolean recordingPDF = false;
int nodeCount = 0;
Node[] nodes = new Node[maxNodes];
boolean[][] edges = new boolean[maxNodes][maxNodes];
Node draggedNode = null; // Used when moving nodes by hand
Node sourceNode = null; // Used when creating new edges by hand
Node targetNode = null; // _ditto_

enum State { NONE, SUSCEPTIBLE, INFECTIOUS, RECOVERED }

class Node {
    int _id;
    float _x, _y;
    private State _state, _nextState;
    float _tween;
    boolean _highlight;

    Node(int id, float x, float y) {
        _id = id;
        _x  = x;
        _y  = y;

        _state     = State.SUSCEPTIBLE;
        _nextState = State.NONE;
        _tween     = 0;
        _highlight = false;
    }

    boolean isSusceptible() { return _state == State.SUSCEPTIBLE; }
    boolean isInfectious()  { return _state == State.INFECTIOUS; }
    boolean isRecovered()   { return _state == State.RECOVERED; }

    void draw() {
        if (_nextState != State.NONE) {
            nextState();
            _nextState = State.NONE;
        }

        color currentColor;

        switch (_state) {
        default:
            currentColor = susceptibleColor;
            break;
        case INFECTIOUS:
            currentColor = infectiousColor;
            break;
        case RECOVERED:
            currentColor = recoveredColor;
            break;
        }

        strokeWeight(nodeSize * 0.2);
        if (_highlight) {
            stroke(100);
        } else {
            stroke(backgroundColor);
        }

        float d = nodeSize;

        if (_tween > 0) {
            color prevColor = susceptibleColor;

            if (_state == State.INFECTIOUS) {
                prevColor = susceptibleColor;

                float scaleFactor = 1.0 + animationScale * sq(sin(_tween * PI));
                d *= scaleFactor;
            } else if (_state == State.RECOVERED) {
                prevColor = infectiousColor;
            }

            currentColor = lerpColor(currentColor, prevColor, _tween);

            _tween -= animationSpeed;
        }

        fill(currentColor);
        ellipse(_x, _y, d, d);
    }

    State nextState() {
        switch (_state) {
        case SUSCEPTIBLE:
            _state = State.INFECTIOUS;
            break;
        case INFECTIOUS:
            _state = State.RECOVERED;
            break;
        default:
            return _state;
        }

        _tween = 1.0;

        return _state;
    }

    void infect() {
        if (!isSusceptible() || _nextState != State.NONE) {
            return;
        }

        _nextState = State.INFECTIOUS;
    }

    void recover() {
        if (!isInfectious() || _nextState != State.NONE) {
            return;
        }

        _nextState = State.RECOVERED;
    }

    float distTo(float x, float y) {
        return dist(_x, _y, x, y);
    }

    float distTo(Node node) {
        return distTo(node._x, node._y);
    }

    ArrayList<Node> neighbors() {
        ArrayList<Node> result = new ArrayList<Node>();

        for (int i = 0; i < nodeCount; ++i) {
            if (i != _id && edges[i][_id]) {
                result.add(nodes[i]);
            }
        }

        return result;
    }

    void isolate() {
        for (int j = 0; j < nodeCount; ++j) {
            removeEdge(_id, j);
        }
    }

    void reset() {
        _state = State.SUSCEPTIBLE;
        _tween = 0;
        _highlight = false;
    }
}

void setup() {
    //size(900, 900);
    fullScreen();
}

void draw() {
    if (recordingPDF) {
        beginRecord(PDF, timestamp() + "_##.pdf");
    }

    background(backgroundColor);

    if (editing) {
        drawUI();

        if (mousePressed) {
            if (sourceNode != null) {
                strokeWeight(edgeWeight + 2);
                stroke(newEdgeColor);

                if (targetNode == null) {
                    line(sourceNode._x, sourceNode._y, mouseX, mouseY);
                } else if (targetNode._id != sourceNode._id) {
                    targetNode._highlight = true;
                    line(sourceNode._x, sourceNode._y, targetNode._x, targetNode._y);
                }
            }
        }
    } else {
        simulateStep();
    }

    drawEdges();
    drawNodes();

    if (recordingPDF) {
        endRecord();
        recordingPDF = false;
    }

    if (recordingMovie) {
        saveFrame("movie/frame-####.png");
    }
}

/* ==============================================================================
 * Interface drawing
 */

void drawUI() {
    noStroke();
    fill(50);
    rect(width/2 - 250, .2 * height, 200, .6 * height);
    rect(width/2 + 50,  .2 * height, 200, .6 * height);

    int[] counts = countStates();
    float[] freqs = { (float)counts[0] / nodeCount,
                      (float)counts[1] / nodeCount,
                      (float)counts[2] / nodeCount };

    fill(120);
    textSize(14);
    textLeading(16);
    text(String.format(Locale.ENGLISH, "density: %.0f%%\nradius: %.0f\ninfection rate: %.1f%%\nrecovery rate: %.1f%%\n\n" +
                "node count: %d/%d\nsusceptible: %.0f%%\ninfected: %.0f%%\nrecovered: %.0f%%\n\n%d FPS",
            100 * hoodDensity, hoodRadius, 100 * infectionRate, 100 * recoveryRate,
            nodeCount, maxNodes, 100 * freqs[0], 100 * freqs[1], 100 * freqs[2], int(frameRate)),
        30, 50);
}

void drawEdges() {
    strokeWeight(edgeWeight);

    for (int i = 0; i < nodeCount; ++i) {
        for (int j = i + 1; j < nodeCount; ++j) {
            if (!edges[i][j]) {
                continue;
            }

            if (nodes[i].isRecovered() || nodes[j].isRecovered()) {
                stroke(passiveEdgeColor);
            } else {
                stroke(activeEdgeColor);
            }

            line(nodes[i]._x, nodes[i]._y, nodes[j]._x, nodes[j]._y);
        }
    }
}

void drawNodes() {
    stroke(backgroundColor);
    strokeWeight(2);

    for (int i = 0; i < nodeCount; ++i) {
        nodes[i].draw();
    }
}

/* ==============================================================================
 * Graph manipulation
 */

Node createRandomNodeAt(float x, float y) {
    if (nodeCount >= maxNodes) {
        return null;
    }

    Node newNode = new Node(nodeCount, x, y);
    nodes[nodeCount] = newNode;

    for (int i = 0; i < nodeCount; ++i) {
        float d = newNode.distTo(nodes[i]);

        if (d < hoodRadius && random(1) < hoodDensity) {
            addEdge(i, nodeCount);
        }
    }

    ++nodeCount;

    return newNode;
}

void addEdge(int i, int j) {
    edges[i][j] = edges[j][i] = true;
}

void removeEdge(int i, int j) {
    edges[i][j] = edges[j][i] = false;
}

void clearGraph() {
    nodeCount = 0;
    nodes = new Node[maxNodes];
    edges = new boolean[maxNodes][maxNodes];
}

Node findNode(float x, float y) {
    Node nearest = null;
    float minDist = 0;

    for (int i = 0; i < nodeCount; ++i) {
        Node n = nodes[i];
        float d = dist(n._x, n._y, x, y);
        if (d <= 1.2 * nodeSize) {
            if (nearest == null || d < minDist) {
                nearest = n;
                minDist = d;
            }
        }
    }

    return nearest;
}

/* ==============================================================================
 * Simulation
 */

void simulateStep() {
    for (int i = 0; i < nodeCount; ++i) {
        if (nodes[i].isInfectious()) {
            for (Node neigh : nodes[i].neighbors()) {
                if (neigh.isSusceptible() && random(1) < infectionRate) {
                    neigh.infect();
                }
            }

            if (random(1) < recoveryRate) {
                nodes[i].recover();
            }
        }
    }
}

/* ==============================================================================
 * Miscellaneous
 */

int[] countStates() {
    int[] counts = { 0, 0, 0 };

    for (int i = 0; i < nodeCount; ++i) {
        if (nodes[i].isSusceptible()) {
            ++counts[0];
        } else if (nodes[i].isInfectious()) {
            ++counts[1];
        } else {
            ++counts[2];
        }
    }

    return counts;
}

/* ==============================================================================
 * Input handling
 */

void mouseReleased() {
    if (!editing) {
        return;
    }

    switch (mouseButton) {
    case LEFT:
        if (draggedNode != null) {
            draggedNode._highlight = false;
            draggedNode = null;
        } else if (sourceNode != null) {
            sourceNode._highlight = false;
            if (targetNode != null && targetNode != sourceNode) {
                addEdge(sourceNode._id, targetNode._id);
                targetNode._highlight = false;
            }
            sourceNode = targetNode = null;
        }
        break;
    }
}

void mouseDragged() {
    if (!editing) {
        return;
    }

    switch (mouseButton) {
    case LEFT:
        if (keyPressed && key == CODED && keyCode == CONTROL) {
            createRandomNodeAt(mouseX + random(-hoodRadius / 2, hoodRadius / 2),
                               mouseY + random(-hoodRadius / 2, hoodRadius / 2));
        } else {
            if (draggedNode != null) {
                draggedNode._highlight = true;
                draggedNode._x = mouseX;
                draggedNode._y = mouseY;
            } else if (sourceNode != null) {
                sourceNode._highlight = true;
                targetNode = findNode(mouseX, mouseY);
            } else {
                draggedNode = findNode(mouseX, mouseY);
                if (draggedNode == null) break;
            }
        }
        break;
    }
}

void mouseClicked() {
    if (!editing) {
        return;
    }

    switch (mouseButton) {
    case LEFT: {
        if (sourceNode != null) {
            break;
        }

        Node n = findNode(mouseX, mouseY);

        if (n == null) {
            createRandomNodeAt(mouseX, mouseY);
        } else {
            n.nextState();
        }
        break; }
    case RIGHT: {
        Node n = findNode(mouseX, mouseY);
        if (n == null) {
            break;
        }
        n.reset();
        break; }
    case CENTER: {
        Node n = findNode(mouseX, mouseY);
        if (n == null) {
            break;
        }
        n.isolate();
        break; }
    }
}

void mousePressed() {
    if (!editing) {
        return;
    }

    switch (mouseButton) {
    case LEFT: {
        Node n = findNode(mouseX, mouseY);

        if (keyPressed && key == CODED && keyCode == SHIFT) {
            sourceNode = n;
        }
        break; }
    }
}

void keyPressed() {
    if (editing && key == 'c') {
        clearGraph();
    } else if (editing && key == 'g') {
        createRandomNodeAt(random(width), random(height));
    } else if (editing && key == 'G') {
        clearGraph();
        for (int i = 0; i < maxNodes; ++i) {
            createRandomNodeAt(random(width), random(height));
        }
    } else if (editing && key == 'r') {
        for (int i = 0; i < nodeCount; ++i) {
            nodes[i].reset();
        }
    } else if (editing && key == 'I') {
        for (int i = 0; i < nodeCount; ++i) {
            if (!nodes[i].isInfectious() && random(1) < infectionRate) {
                nodes[i].infect();
            }
        }
    } else if (key == ' ') {
        if (draggedNode == null && sourceNode == null) {
            editing = !editing;
        }
    } else if (key == '[') {
        infectionRate = max(infectionRate - 0.001, 0.0);
    } else if (key == ']') {
        infectionRate = min(infectionRate + 0.001, 1.0);
    } else if (key == '{') {
        recoveryRate = max(recoveryRate - 0.001, 0.0);
    } else if (key == '}') {
        recoveryRate = min(recoveryRate + 0.001, 1.0);
    } else if (key == 'm') {
        recordingMovie = !recordingMovie;
    } else if (key == 'p') {
        recordingPDF = true;
    } else if (key == 's') {
        saveFrame(timestamp() + "_##.png");
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

/* vim: set et sw=4 sts=4 ai cin: */