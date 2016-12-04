import java.util.Calendar;

float nodeSize = 20;

enum State { IMMUNE, SUSCEPTIBLE, EXPOSED, INFECTIVE, RECOVERED }

class Node {
    float _x, _y;
    boolean _active;
    State _state;

    Node(float x, float y) {
        _x = x;
        _y = y;
        _active = false;
        _state = State.IMMUNE;
    }

    void draw() {
        switch (_state) {
        case IMMUNE:
            fill(#7da1db);
            break;
        case SUSCEPTIBLE:
            fill(#74ccba);
            break;
        case EXPOSED:
            fill(#d6c77e);
            break;
        case INFECTIVE:
            fill(#db9481);
            break;
        case RECOVERED:
            fill(#abb8ce);
            break;
        }

        if (_active) {
            strokeWeight(3);
            stroke(60);
        } else {
            noStroke();
        }

        ellipse(_x, _y, nodeSize, nodeSize);
    }
}

class Edge {
    Node _from, _to;

    Edge(Node from, Node to) {
        _from = from;
        _to   = to;
    }
}

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();
Node draggedNode = null;

void setup() {
    size(900, 900);
}

void draw() {
    background(230);

    drawEdges();
    drawNodes();
}

void drawEdges() {
    strokeWeight(2);
    stroke(0, 40);

    for (Edge edge : edges) {
        line(edge._from._x, edge._from._y, edge._to._x, edge._to._y);
    }
}

void drawNodes() {
    stroke(40);
    strokeWeight(2);

    for (Node node : nodes) {
        node.draw();
    }
}

void mouseReleased() {
    switch (mouseButton) {
    case LEFT:
        if (draggedNode != null) {
            draggedNode._active = false;
            draggedNode = null;
        }
        break;
    }
}

void mouseDragged() {
    switch (mouseButton) {
    case LEFT:
        if (draggedNode == null) {
            draggedNode = findNode(mouseX, mouseY);
            if (draggedNode == null) break;
        }

        draggedNode._active = true;
        draggedNode._x = mouseX;
        draggedNode._y = mouseY;
        break;
    }
}

void mouseClicked() {
    switch (mouseButton) {
    case LEFT:
        createNodeAt(mouseX, mouseY);
        break;
    case RIGHT: {
        Node n = findNode(mouseX, mouseY);
        if (n == null) break;
        removeNode(n);
        break; }
    case CENTER: {
        Node n = findNode(mouseX, mouseY);
        if (n == null) break;
        switch (n._state) {
        case IMMUNE:
            n._state = State.SUSCEPTIBLE;
            break;
        case SUSCEPTIBLE:
            n._state = State.EXPOSED;
            break;
        case EXPOSED:
            n._state = State.INFECTIVE;
            break;
        case INFECTIVE:
            n._state = State.RECOVERED;
            break;
        case RECOVERED:
            n._state = State.SUSCEPTIBLE;
            break;
        }
        break; }
    }
}

Node createNodeAt(float x, float y) {
    Node newNode = new Node(mouseX, mouseY);
    nodes.add(newNode);
    for (Node neigh : nodes) {
        if (neigh != newNode && random(10) > 6) {
            edges.add(new Edge(newNode, neigh));
        }
    }

    return newNode;
}

void removeNode(Node node) {
    nodes.remove(node);

    ArrayList<Edge> found = new ArrayList<Edge>();
    for (Edge edge : edges) {
        if (edge._from == node || edge._to == node) {
            found.add(edge);
        }
    }

    edges.removeAll(found);
}

Node findNode(float x, float y) {
    Node nearest = null;
    float distance = 0;

    for (Node n : nodes) {
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

void keyPressed() {
    if (key == 'c') {
        nodes.clear();
        edges.clear();
    } else if (key == 's') {
        saveFrame(timestamp() + "_##.png");
    }
}

String timestamp() {
    Calendar now = Calendar.getInstance();
    return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

/* vim: set et sw=4 sts=4 ai cin: */
