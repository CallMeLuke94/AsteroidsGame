class Spaceship {
  float x;
  float y;
  float angle;
  PVector pos;
  PVector vel;
  PVector acc;

  float lazX;
  float lazY;

  boolean lazerOn;
  boolean live;

  float mass = 5;
  float air = 0.03;

  int s = 40;
  int r = 15;


  Spaceship(float x_, float y_) {
    x = x_;
    y = y_;
    pos = new PVector(x, y);

    angle = 0;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);

    lazerOn = false;
    live = true;
  }

  void display() {
    if (live) {
      if (keyPressed) {
        if (key == 'w' || key == 'a' || key == 's' || key == 'd') { 
          //a = vel.heading();
        }
      }

      pushMatrix();
      translate(pos.x, pos.y);
      rotate(angle);
      laser(100);
      model(0.5);
      lazX = modelX(200, 0, 0);
      lazY = modelY(200, 0, 0);
      popMatrix();
    }
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }

  void thrust(float s) {
    if (keyPressed) {
      if (key == 'z') {
        PVector dir = PVector.fromAngle(angle);
        dir.mult(s);
        applyForce(dir);
      }
    }
  }

  void drive(float s) {
    if (keyPressed) {
      if (key == 'w') {
        PVector dir = new PVector(0, -1);
        dir.mult(s);
        applyForce(dir);
      } else if (key == 's') {
        PVector dir = new PVector(0, 1);
        dir.mult(s);
        applyForce(dir);
      } else if (key == 'a') {
        PVector dir = new PVector(-1, 0);
        dir.mult(s);
        applyForce(dir);
      } else if (key == 'd') {
        PVector dir = new PVector(1, 0);
        dir.mult(s);
        applyForce(dir);
      }
    }
  }

  void laser(float len) {
    if (keyPressed) {
      if (key == 'x') {
        strokeWeight(3);
        stroke(255, 0, 0);
        line(0, 0, len, 0);
        strokeWeight(1);
        lazerOn = true;
      }
    }
  }

  void turnToMouse(float l) {
    angle = PVector.sub(new PVector(mouseX, mouseY), pos).heading();
    if (mousePressed) {
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(angle);
      strokeWeight(3);
      stroke(255, 0, 0);
      line(0, 0, l, 0);
      strokeWeight(1);
      popMatrix();
    }
  }

  void spin() {
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == LEFT) {
          angle -= 000.1;
        } else if (keyCode == RIGHT) {
          angle += 000.1;
        }
      }
    }
  }

  void drag() {
    float speed = vel.mag();
    float dragMag = air*speed*speed;

    PVector drag = vel.copy();
    drag.mult(-1);
    drag.normalize();
    drag.mult(dragMag);
    applyForce(drag);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  void edges() {
    if (pos.x > width) {
      pos.x = 0;
      //pos.y = height-pos.y;
    } else if (pos.x < 0) {
      pos.x = width;
      //pos.y = height-pos.y;
    } else if (pos.y > height) {
      pos.y = 0;
    } else if (pos.y < 0) {
      pos.y = height;
    }
  }
}