boolean started = false;

int total = 10;

Spaceship s;
float p = 1;

Asteroid[] rocks = new Asteroid[total];

int lives, score;
long startTime, endTime;
boolean time = true;
PFont f, g;

void setup() {
  s = new Spaceship(width/2, 3*height/4);

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
    text("Astroids: " + (total - score), 20, 30);
    textAlign(RIGHT);
    text("Lives: " + lives, width-20, 30);

    gameEnd();

    s.l = false;
  }
}

void gameStart() {
  textAlign(CENTER);
  textFont(f);
  fill(255);
  text(" Destroy all asteroids \n as quickly as possible \n without getting hit!", width/2, 0.8*height/4);
  rectMode(CENTER);
  stroke(255);
  noFill();
  rect(width/2, height/2 - 10, 202, 56);
  if (mouseX > width/2-75 && mouseX < width/2+75 && mouseY > height/2 - 28 && mouseY < height/2 + 28) {
    fill(100);
    if (mousePressed) {
      started = true;
      restartGame();
    }
  } else {
    fill(255);
  }
  textFont(g);
  text("Start Game", width/2, height/2);
  rectMode(CORNER);
}


void gameEnd() {
  textFont(g);
  if (score == rocks.length) {
    if (time) {
      endTime = System.nanoTime();
      time = false;
    }
    fill(0, 255, 0);
    textAlign(CENTER);
    text("You Win!", width/2, height/2);
    restartButton();
    fill(255);
    text("Time: " + (floor((endTime - startTime) / 1E9)) + "s", width/2, height/2+120);
  } else if (lives == 0) {
    if (time) {
      endTime = System.nanoTime();
      time = false;
    }
    fill(255, 0, 0);
    textAlign(CENTER);
    text("Game Over", width/2, height/2);
    s.live = false;
    restartButton();
    fill(255);
    text("Time: " + (floor((endTime - startTime) / 1E9)) + "s", width/2, height/2+120);
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
  startTime = System.nanoTime();

  lives = 1;
  score = 0;

  for (int i = 0; i < rocks.length; i++) {
    rocks[i] = new Asteroid(random(30, 80), new PVector(random(-width/3, width/3), random(height)), PVector.random2D().mult(random(0.5, 1.5)), int(random(10, 21)));
    //rocks[i] = new Asteroid(random(30, 80), new PVector(random(width), random(height)), new PVector(0, 0), int(random(10, 21)));
    rocks[i].generate();
  }

  time = true;
  s.live = true;
  s.pos = new PVector(width/2, height/2);
}