boolean started = false;

Spaceship s;
float p = 1;

Asteroid[] rocks = new Asteroid[10];

int lives = 3;
int score = 0;
PFont f, g;

void setup() {
  s = new Spaceship(width/2, 3*height/4);

  for (int i = 0; i < rocks.length; i++) {
    rocks[i] = new Asteroid(random(30, 80), new PVector(random(-width/3, width/3), random(height)), PVector.random2D().mult(random(0.5, 1.5)), int(random(5, 21)));
    rocks[i].generate();
  }

  f = createFont("SourceCodePro-Regular", 22);
  g = createFont("SourceCodePro-Regular", 32);
  textFont(f);

  //fullScreen(P2D);
  size(800, 600, P2D);
  background(0);
}

void draw() {
  background(0);
  if (!started) {
    s.edges();
    s.update();
    s.spin();
    s.thrust(p);
    //s.drive(p);
    s.drag();
    s.display();
    gameStart();
  } else {
    //s.turnToMouse(100);

    s.edges();
    s.update();
    s.spin();
    s.thrust(p);
    //s.drive(p);
    s.drag();
    s.display();

    for (int i = 0; i < rocks.length; i++) {
      rocks[i].edges();
      rocks[i].update();
      rocks[i].display();
      rocks[i].collide(s);
      rocks[i].shot(s);
    }

    if (lives < 0) {
      lives = 0;
    }

    fill(255);
    textAlign(LEFT);
    text("Score: " + score, 20, 30);
    textAlign(RIGHT);
    text("Lives: " + lives, width-20, 30);

    gameEnd();

    s.l = false;
  }
}

void gameStart() {
  rectMode(CENTER);
  stroke(255);
  noFill();
  rect(width/2, height/2 - 10, 200, 56);
  if (mouseX > width/2-75 && mouseX < width/2+75 && mouseY > height/2 - 28 && mouseY < height/2 + 28) {
    fill(100);
    if (mousePressed) {
      started = true;
      restartGame();
    }
  } else {
    fill(255);
  }
  textAlign(CENTER);
  textFont(g);
  text("Start Game", width/2, height/2);
  rectMode(CORNER);
}


void gameEnd() {
  textAlign(CENTER);
  textFont(g);
  if (score == rocks.length) {
    fill(0, 255, 0);
    text("You Win!", width/2, height/2);
    restartButton();
  } else if (lives == 0) {
    fill(255, 0, 0);
    text("Game Over", width/2, height/2);
    s.live = false;
    restartButton();
  }
}

void restartButton() {
  rectMode(CENTER);
  stroke(255);
  noFill();
  rect(width/2, height/2 + 46, 150, 56);
  if (mouseX > width/2-75 && mouseX < width/2+75 && mouseY > height/2 + 46 - 28 && mouseY < height/2 + 46 + 28) {
    fill(100);
    if (mousePressed) {
      restartGame();
    }
  } else {
    fill(255);
  }
  textAlign(CENTER);
  textFont(g);
  text("restart", width/2, height/2 + 55);
  rectMode(CORNER);
}

void restartGame() {
  lives = 3;
  score = 0;

  for (int i = 0; i < rocks.length; i++) {
    rocks[i] = new Asteroid(random(30, 80), new PVector(random(-width/3, width/3), random(height)), PVector.random2D().mult(random(0.5, 1.5)), int(random(5, 21)));
    rocks[i].generate();
  }

  s.live = true;
  s.pos = new PVector(width/2, height/2);
}