import java.util.Calendar;

/* Tweak these and see what happens */

/* ** Behaviour */
int maxNodes = 300;
float nodeSize = 20;
float hoodDensity = 0.3;
float animationSpeed = 0.04;
float animationScale = 0.5;
float hoodRadius = 100;

/* ** Visuals */
color backgroundColor = color(30);
float edgeWeight = 2;
color activeEdgeColor = color(255, 50);
color passiveEdgeColor = color(255, 20);
color newEdgeColor = color(255, 90);
color susceptibleColor = #61e8cd;
color infectiousColor = #e8635c;
color recoveredColor = #555659;

/* `~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~^~._,~`~._,~ */

enum State { SUSCEPTIBLE, INFECTIOUS, RECOVERED }

class Node {
    int _id;
    float _x, _y;
    boolean _highlight;
    State _state;
    float _tween;

    Node(int id, float x, float y) {
        _id = id;
        _x = x;
        _y = y;
        _highlight = false;
        _state = State.SUSCEPTIBLE;
        _tween = 0;
    }

    void draw() {
        color stateColor;

        switch (_state) {
        default:
            stateColor = susceptibleColor;
            break;
        case INFECTIOUS:
            stateColor = infectiousColor;
            break;
        case RECOVERED:
            stateColor = recoveredColor;
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

            stateColor = lerpColor(stateColor, prevColor, _tween);

            _tween -= animationSpeed;
        }

        fill(stateColor);
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

    float distance(float x, float y) {
        return dist(_x, _y, x, y);
    }

    float distance(Node node) {
        return distance(node._x, node._y);
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

boolean editing = true;
int nodeCount = 0;
Node[] nodes = new Node[maxNodes];
boolean[][] edges = new boolean[maxNodes][maxNodes];
Node draggedNode = null; // Used when moving nodes by hand
Node sourceNode = null; // Used when creating new edges by hand
Node targetNode = null; // _ditto_

void setup() {
    //size(900, 900);
    fullScreen();
}

void draw() {
    background(backgroundColor);

    if (editing) {
        drawUI();
    }

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

    drawEdges();
    drawNodes();
}

void drawUI() {
    noStroke();
    fill(50);
    rect(width/2 - 250, .2 * height, 200, .6 * height);
    rect(width/2 + 50,  .2 * height, 200, .6 * height);

    int[] stateCounts = countStates();

    fill(120);
    textSize(14);
    textLeading(16);
    text(String.format("node count: %d\nsusceptible: %d\ninfected: %d\nresitant: %d",
            nodeCount, stateCounts[0], stateCounts[1], stateCounts[2]),
        30, 50);
}

void drawEdges() {
    strokeWeight(edgeWeight);

    for (int i = 0; i < nodeCount; ++i) {
        for (int j = i + 1; j < nodeCount; ++j) {
            if (!edges[i][j]) {
                continue;
            }

            if (nodes[i]._state == State.RECOVERED || nodes[j]._state == State.RECOVERED) {
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

Node createRandomNodeAt(float x, float y) {
    if (nodeCount >= maxNodes) {
        return null;
    }

    Node newNode = new Node(nodeCount, x, y);
    nodes[nodeCount] = newNode;

    for (int i = 0; i < nodeCount; ++i) {
        float d = newNode.distance(nodes[i]);

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
    float distance = 0;

    for (int i = 0; i < nodeCount; ++i) {
        Node n = nodes[i];
        float d = dist(n._x, n._y, x, y);
        if (d <= 1.5 * nodeSize) {
            if (nearest == null || d < distance) {
                nearest = n;
                distance = d;
            }
        }
    }

    return nearest;
}

int[] countStates() {
    int[] counts = { 0, 0, 0 };

    for (int i = 0; i < nodeCount; ++i) {
        switch (nodes[i]._state) {
        case SUSCEPTIBLE:
            ++counts[0];
            break;
        case INFECTIOUS:
            ++counts[1];
            break;
        case RECOVERED:
            ++counts[2];
            break;
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
        n.isolate();
        break; }
    case CENTER: {
        Node n = findNode(mouseX, mouseY);
        if (n == null) {
            break;
        }
        n.reset();
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
    } else if (editing && key == 'r') {
        for (int i = nodeCount; i < maxNodes; ++i) {
            createRandomNodeAt(random(width), random(height));
        }
    } else if (key == ' ') {
        if (draggedNode == null && sourceNode == null) {
            editing = !editing;
        }
    } else if (key == 's') {
        saveFrame(timestamp() + "_##.png");
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

/* vim: set et sw=4 sts=4 ai cin: */
