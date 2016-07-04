class Asteroid {
  PVector pos;
  PVector vel;
  float r;
  int c;
  PVector[] vertices;

  boolean live = true;

  Asteroid(float r_, PVector pos_, PVector vel_, int c_) {
    pos = pos_;
    vel = vel_;
    r = r_;
    c = c_;
    vertices = new PVector[c];
  }

  void display() {
    stroke(255);
    noFill();
    pushMatrix();
    translate(pos.x, pos.y);
    beginShape();
    for (int i = 1; i < c; i++) {
      vertex(vertices[i].x, vertices[i].y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  void generate() {
    for (int i = 1; i < c; i++) {
      float a = TWO_PI*i/c;
      PVector v = PVector.fromAngle(a);
      v.mult(random(0.8, 1.2)*r/2);
      vertices[i] = v;
    }
  }


  void update() {
    pos.add(vel);
  }

  void edges() {
    if (live) {
      if (pos.x > width) {
        pos.x = 0;
      } else if (pos.x < 0) {
        pos.x = width;
      } else if (pos.y > height) {
        pos.y = 0;
      } else if (pos.y < 0) {
        pos.y = height;
      }
    }
  }

  void collide(Spaceship s) {
    if (pos.dist(s.pos) < r*0.8) {
      lives--;
      s.pos = new PVector(width/2, height/2);
      s.vel = new PVector(0, 0);
    }
  }

  void shot(Spaceship s) {
    if (s.l) {
      noStroke();
      fill(0, 0, 255);
      PVector laz = new PVector(s.lazX, s.lazY);
      PVector[] lazs = new PVector[9];
      for (int i = 0; i <= 8; i++) {
        lazs[i] = laz.copy().sub(s.pos.copy());
        lazs[i] = lazs[i].mult(1-float(i)/10);
        lazs[i] = lazs[i].add(s.pos.copy());
        if (pos.dist(lazs[i]) < r/2) {
          destroy();
        }
      }
    }
  }

  void destroy() {
    live = false;
    pos = new PVector(-400, -400);
    vel = new PVector(0, 0);
    score++;
  }
}