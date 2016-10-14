class Line {
  public PVector start, end;
  
  public Line(PVector start, PVector end) {
    this.start = start;
    this.end = end;
  }
  
  public void draw() {
    line(start.x, start.y, end.x, end.y);
  }
}

class Triangle {
  public PVector v1, v2, v3;
  
  public Triangle(PVector v1, PVector v2, PVector v3) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
  }
  
  public Line[] getEdges() {
    Line[] lines = {
      new Line(v1, v2),
      new Line(v2, v3),
      new Line(v3, v1)
    };
    
    return lines;
  }
  
  public void draw() {
    triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
  }
}