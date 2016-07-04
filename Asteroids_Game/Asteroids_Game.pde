import java.util.*;

boolean started = false;

ArrayList<Integer> gameTimes = new ArrayList<Integer>();

int total = 8;

Spaceship s;
float power = 1;

Asteroid[] rocks = new Asteroid[total];

int lives, score;
long startTime, endTime; 
int thisTime;
boolean time = true;
PFont f, g;

void setup() {
  s = new Spaceship(width/2, 3*height/4);
  s.angle = -HALF_PI;

  f = createFont("SourceCodePro-Regular", 22);
  g = createFont("SourceCodePro-Regular", 32);
  textFont(f);

  //fullScreen(P2D);
  size(800, 600, P2D);
  background(0);
}

void draw() {
  background(0);

  s.edges();
  s.update();
  s.spin();
  s.thrust(power);
  s.drag();
  s.display();

  if (!started) {
    gameStart();
  } else {

    for (int i = 0; i < rocks.length; i++) {
      rocks[i].edges();
      rocks[i].wobble();
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

    if (score == rocks.length) {
      if (time) {
        endTime = System.nanoTime();
        time = false;
        thisTime = floor((endTime - startTime) / 1E9);
        gameTimes.add(thisTime);
      }
      gameWon();
    }

    if (lives == 0) {
      if (time) {
        endTime = System.nanoTime();
        time = false;
        thisTime = floor((endTime - startTime) / 1E9);
      }
      gameLost();
      if (gameTimes.size() > 0) {
        bestTime();
      }
    }
    s.lazerOn = false;
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

  if (keyPressed) {
    if (key == ENTER || key == RETURN) {
      started = true;
      restartGame();
    }
  }

  if (mouseX > width/2 - 102 && mouseX < width/2 + 102 && mouseY > height/2 - 10 - 29 && mouseY < height/2 - 10 + 29) {
    fill(80);
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


void gameWon() {
  textFont(g);
  fill(0, 255, 0);
  textAlign(CENTER);
  text("Success!", width/2, height/2-65);
  restartButton();

  fill(255);
  text("Time: " + thisTime + "s", width/2, height/2+55);
  bestTime();
}

void gameLost() {  
  fill(255, 0, 0);
  textAlign(CENTER);
  text("Game Over", width/2, height/2-65);
  s.live = false;
  restartButton();
  
  fill(255);
  text("Time: " + thisTime + "s", width/2, height/2+55);
}

void restartButton() {
  rectMode(CENTER);
  stroke(255);
  noFill();
  rect(width/2, height/2 -19, 150, 56);

  if (keyPressed) {
    if (key == ENTER || key == RETURN) {
      started = true;
      restartGame();
    }
  }

  if (mouseX > width/2 - 76 && mouseX < width/2 + 76 && mouseY > height/2 - 19 - 29 && mouseY < height/2 - 19 + 29) {
    fill(80);
    if (mousePressed) {
      restartGame();
    }
  } else {
    fill(255);
  }

  textAlign(CENTER);
  textFont(g);
  text("restart", width/2, height/2 - 10);
  rectMode(CORNER);
}

void restartGame() {
  startTime = System.nanoTime();

  lives = 1;
  score = 0;

  for (int i = 0; i < rocks.length; i++) {
    rocks[i] = new Asteroid(random(30, 80), new PVector(random(-width/3, width/3), random(height)), PVector.random2D().mult(random(0.5, 1.5)), int(random(10, 21)));
    //rocks[i] = new Asteroid(random(30, 80), new PVector(width/2 + 100, height/2 + 100), new PVector(0, 0), int(random(10, 21)));
    rocks[i].generate();
  }

  time = true;
  s.live = true;
  s.pos = new PVector(width/2, height/2);
  s.vel = new PVector(0, 0);
}

void bestTime() {
  Collections.sort(gameTimes);
  fill(255);
  textAlign(CENTER);
  textFont(f);
  text("Best time: " + gameTimes.get(0) + "s", width/2, height/2 + 95);
}