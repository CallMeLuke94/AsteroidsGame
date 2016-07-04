class Asteroid {
  PVector pos;
  PVector vel;
  float radius;  //actually diameter
  int corners;
  PVector[] vertices;
  float angle = 0;
  float spin = degrees(random(-0.0001, 0.0001));

  boolean live = true;

  Asteroid(float r_, PVector pos_, PVector vel_, int c_) {
    pos = pos_;
    vel = vel_;
    radius = r_;
    corners = c_;
    vertices = new PVector[corners];
  }

  void display() {
    stroke(255);
    noFill();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    beginShape();
    for (int i = 0; i < corners; i++) {
      vertex(vertices[i].x, vertices[i].y);
    }
    endShape(CLOSE);
    popMatrix();
    angle += spin;
  }

  void generate() {
    for (int i = 0; i < corners; i++) {
      float a = TWO_PI*i/corners;
      PVector v = PVector.fromAngle(a);
      v.mult(random(0.8, 1.2)*radius/2);
      vertices[i] = v.copy();
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
    if (pos.dist(s.pos) < radius*0.8) {
      lives -= 1;
      s.pos = new PVector(width/2, height/2);
      s.vel = new PVector(0, 0);
    }
  }

  void shot(Spaceship s) {
    if (s.lazerOn) {
      noStroke();
      fill(0, 0, 255);
      PVector laz = new PVector(s.lazX, s.lazY);
      PVector[] lazs = new PVector[9];
      for (int i = 0; i <= 8; i++) {
        lazs[i] = laz.copy().sub(s.pos.copy());
        lazs[i] = lazs[i].mult(1-float(i)/10);
        lazs[i] = lazs[i].add(s.pos.copy());
        if (pos.dist(lazs[i]) < radius/2) {
          destroy();
        }
      }
    }
  }

  void destroy() {
    live = false;
    pos = new PVector(-400, -400);
    vel = new PVector(0, 0);
    score += 1;
  }

  void wobble() {
    float chance = random(0, 1);
    if (chance < 0.1) {
      float anotherChance = random(0, 1);
      if (anotherChance < 0.5) {
        vel.rotate(radians(noise(pos.x, pos.y)));
      } else {
        vel.rotate(-radians(noise(pos.x, pos.y)));
      }
    }
  }
}