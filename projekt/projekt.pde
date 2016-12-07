import java.util.Calendar;
import java.util.Locale;
import processing.pdf.*;

// Tweak these and see what happens

// -- Structure
int maxNodes      = 200;
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

boolean editing        = true;
boolean recordingMovie = false;
boolean recordingPDF   = false;

Graph graph;

Node draggedNode = null; // Used when moving nodes by hand
Node sourceNode  = null; // Used when creating new edges by hand
Node targetNode  = null; // _ditto_

enum State { NONE, SUSCEPTIBLE, INFECTIOUS, RECOVERED }

class Graph {
    private int         _nodeCount;
    private Node[]      _nodes;
    private boolean[][] _edges;

    Graph() {
        clear();
    }

    int size() {
        return _nodeCount;
    }

    Node getNode(int i) {
        if (i < 0 || i >= _nodeCount) {
            return null;
        }

        return _nodes[i];
    }

    Node addNode(float x, float y) {
        if (_nodeCount >= maxNodes) {
            return null;
        }

        Node node = _nodes[_nodeCount] = new Node(_nodeCount, this, x, y);

        ++_nodeCount;

        return node;
    }

    boolean hasEdge(int i, int  j) {
        if (i < 0 || i >= _nodeCount || j < 0 || j >= _nodeCount || i == j) {
            return false;
        }

        return _edges[i][j];
    }

    void addEdge(int i, int j) {
        if (i < 0 || i >= _nodeCount || j < 0 || j >= _nodeCount || i == j) {
            return;
        }

        _edges[i][j] = _edges[j][i] = true;
    }

    void removeEdge(int i, int j) {
        if (i < 0 || i >= _nodeCount || j < 0 || j >= _nodeCount || i == j) {
            return;
        }

        _edges[i][j] = _edges[j][i] = false;
    }

    void addHoodEdges(int i) {
        if (i < 0 || i >= _nodeCount) {
            return;
        }

        addHoodEdges(_nodes[i]);
    }

    void addHoodEdges(Node node) {
        for (int i = 0; i < _nodeCount; ++i) {
            if (i == node._id) {
                continue;
            }

            float d = node.distTo(_nodes[i]);
            if (d < hoodRadius && random(1) < hoodDensity) {
                addEdge(i, node._id);
            }
        }
    }

    void clear() {
        _nodeCount = 0;
        _nodes     = new Node[maxNodes];
        _edges     = new boolean[maxNodes][maxNodes];
    }

    void resetNodes() {
        for (int i = 0; i < _nodeCount; ++i) {
            _nodes[i].reset();
        }
    }

    Node nodeAt(float x, float y) {
        Node nearest = null;
        float minDist = 0;

        for (int i = 0; i < _nodeCount; ++i) {
            float d = dist(_nodes[i]._x, _nodes[i]._y, x, y);

            if (d <= 1.2 * nodeSize) {
                if (nearest == null || d < minDist) {
                    nearest = _nodes[i];
                    minDist = d;
                }
            }
        }

        return nearest;
    }

    void draw() {
        drawEdges();
        drawNodes();
    }

    private void drawEdges() {
        strokeWeight(edgeWeight);

        for (int i = 0; i < _nodeCount; ++i) {
            for (int j = i + 1; j < _nodeCount; ++j) {
                if (!_edges[i][j]) {
                    continue;
                }

                if (_nodes[i].recovered() || _nodes[j].recovered()) {
                    stroke(passiveEdgeColor);
                } else {
                    stroke(activeEdgeColor);
                }

                line(_nodes[i]._x, _nodes[i]._y, _nodes[j]._x, _nodes[j]._y);
            }
        }
    }

    private void drawNodes() {
        stroke(backgroundColor);
        strokeWeight(2);

        for (int i = 0; i < _nodeCount; ++i) {
            _nodes[i].draw();
        }
    }
}

class Node {
    int           _id;
    private Graph _parent;
    float         _x, _y;
    float         _tween;
    boolean       _highlight;
    private State _state, _nextState;

    Node(int id, Graph parent, float x, float y) {
        _id     = id;
        _parent = parent;
        _x      = x;
        _y      = y;

        _state     = State.SUSCEPTIBLE;
        _nextState = State.NONE;
        _tween     = 0;
        _highlight = false;
    }

    boolean susceptible() { return _state == State.SUSCEPTIBLE; }
    boolean infectious()  { return _state == State.INFECTIOUS; }
    boolean recovered()   { return _state == State.RECOVERED; }

    void draw() {
        if (_nextState != State.NONE) {
            nextState();
            _nextState = State.NONE;
        }

        color currentColor;

        switch (_state) {
        case SUSCEPTIBLE:
            currentColor = susceptibleColor;
            break;
        case INFECTIOUS:
            currentColor = infectiousColor;
            break;
        default:
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

    private void nextState() {
        switch (_state) {
        case SUSCEPTIBLE:
            _state = State.INFECTIOUS;
            break;
        case INFECTIOUS:
            _state = State.RECOVERED;
            break;
        default:
            return;
        }

        _tween = 1.0;
    }

    void infect() {
        if (!susceptible() || _nextState != State.NONE) {
            return;
        }

        _nextState = State.INFECTIOUS;
    }

    void recover() {
        if (!infectious() || _nextState != State.NONE) {
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

        for (int i = 0; i < _parent.size(); ++i) {
            if (i != _id && _parent.hasEdge(i, _id)) {
                result.add(_parent.getNode(i));
            }
        }

        return result;
    }

    void isolate() {
        for (int j = 0; j < _parent.size(); ++j) {
            _parent.removeEdge(_id, j);
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

    graph = new Graph();
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
        simulateStep(graph);
    }

    graph.draw();

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

    int[] counts = countStates(graph);
    float[] freqs = { (float)counts[0] / graph.size(),
                      (float)counts[1] / graph.size(),
                      (float)counts[2] / graph.size() };

    fill(120);
    textSize(14);
    textLeading(16);
    text(String.format(Locale.ENGLISH, "density: %.0f%%\nradius: %.0f\ninfection rate: %.1f%%\nrecovery rate: %.1f%%\n\n" +
                "node count: %d/%d\nsusceptible: %.0f%%\ninfected: %.0f%%\nrecovered: %.0f%%\n\n%d FPS",
            100 * hoodDensity, hoodRadius, 100 * infectionRate, 100 * recoveryRate,
            graph.size(), maxNodes, 100 * freqs[0], 100 * freqs[1], 100 * freqs[2], int(frameRate)),
        30, 50);
}

/* ==============================================================================
 * Simulation
 */

void simulateStep(Graph graph) {
    for (int i = 0; i < graph.size(); ++i) {
        Node node = graph.getNode(i);

        if (node.infectious()) {
            for (Node neigh : node.neighbors()) {
                if (neigh.susceptible() && random(1) < infectionRate) {
                    neigh.infect();
                }
            }

            if (random(1) < recoveryRate) {
                node.recover();
            }
        }
    }
}

/* ==============================================================================
 * Miscellaneous
 */

int[] countStates(Graph graph) {
    int[] counts = { 0, 0, 0 };

    for (int i = 0; i < graph.size(); ++i) {
        if (graph.getNode(i).susceptible()) {
            ++counts[0];
        } else if (graph.getNode(i).infectious()) {
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
                graph.addEdge(sourceNode._id, targetNode._id);
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
            Node n = graph.addNode(mouseX + random(-hoodRadius / 2, hoodRadius / 2),
                                   mouseY + random(-hoodRadius / 2, hoodRadius / 2));
            graph.addHoodEdges(n);
        } else {
            if (draggedNode != null) {
                draggedNode._highlight = true;
                draggedNode._x = mouseX;
                draggedNode._y = mouseY;
            } else if (sourceNode != null) {
                sourceNode._highlight = true;
                targetNode = graph.nodeAt(mouseX, mouseY);
            } else {
                draggedNode = graph.nodeAt(mouseX, mouseY);
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

        Node n = graph.nodeAt(mouseX, mouseY);

        if (n == null) {
            Node newNode = graph.addNode(mouseX, mouseY);
            graph.addHoodEdges(newNode);
        } else {
            n.nextState();
        }
        break; }
    case RIGHT: {
        Node n = graph.nodeAt(mouseX, mouseY);
        if (n == null) {
            break;
        }
        n.reset();
        break; }
    case CENTER: {
        Node n = graph.nodeAt(mouseX, mouseY);
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
        Node n = graph.nodeAt(mouseX, mouseY);

        if (keyPressed && key == CODED && keyCode == SHIFT) {
            sourceNode = n;
        }
        break; }
    }
}

void keyPressed() {
    if (editing && key == 'c') {
        graph.clear();
    } else if (editing && key == 'g') {
        Node n = graph.addNode(random(width), random(height));
        graph.addHoodEdges(n);
    } else if (editing && key == 'G') {
        graph.clear();
        for (int i = 0; i < maxNodes; ++i) {
            Node n = graph.addNode(random(width), random(height));
            graph.addHoodEdges(n);
        }
    } else if (editing && key == 'r') {
        graph.resetNodes();
    } else if (editing && key == 'I') {
        for (int i = 0; i < graph.size(); ++i) {
            if (!graph.getNode(i).infectious() && random(1) < infectionRate) {
                graph.getNode(i).infect();
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
