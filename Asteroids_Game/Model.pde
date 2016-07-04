void model(float size) {
  scale(size);

  if (keyPressed) {
    if (key == 'z') {
      for (int i = 8; i > 0; i--) {
        noStroke();
        fill(255, 200, 0);
        ellipse(-28-i*6, -17, 16-2*i, 16-2*i);
        ellipse(-28-i*6, 17, 16-2*i, 16-2*i);
      }
    }
  }



  stroke(100);
  fill(255);
  triangle(-20, 30, -20, -30, 44, 0);
  rect(-30, 8, 10, 18);
  rect(-30, -26, 10, 18);
}

// key == 'w' || key == 'a' || key == 's' || key == 'd' || 