// Variabel Global
// 0: Initial Screen
// 1: Game Screen
// 2: Game-over Screen

float ballX, ballY;        
int ballSize = 20;        
int ballColor = color(0);  
float gravity = 1;        
float ballSpeedVert = 0;  
float airFriction = 0.0001; 
float friction = 0.1;     

color racketColor = color(0);
float racketWidth = 100; 
float racketHeight = 10;
int racketBounceRate = 20; 

int wallSpeed = 5;
int wallInterval = 1000;
float lastAddTime = 0;
int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 80;
color wallColors = color(255, 0, 0);

ArrayList<int[]> walls = new ArrayList<int[]>();
int score = 0;
int wallRadius = 50;

int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;

float ballSpeedHorizon = 10; 

int gameScreen = 0;

void setup() {
  size(500, 500);
  ballX = width/4; 
  ballY = height/5;
}

void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}

void gameOver() {
  gameScreen = 2;
}

// SCREEN CONTENTS
void initScreen() {
  background(0);
  textAlign(CENTER);
  text("press play", height/2, width/2);
}

void gameScreen() {
  background(255);
  drawBall();
  applyGravity(); 
  keepInScreen(); 
  drawRacket(); 
  watchRacketBounce(); 
  applyHorizontalSpeed(); 
  wallAdder();
  wallHandler();
  drawHealthBar();
  printScore();
}

// INPUTS
public void mousePressed() {
  // Jika pemain mengklik layar awal maka game dimulai
  if (gameScreen == 0) {
    startGame();
  } else if (gameScreen == 2) {
    restart();
  }
}

// Metode ini mengatur variabel-variabel yang diperlukan untuk memulai game
void startGame() {
  gameScreen = 1;
}

void restart() {
  score = 0;
  health = maxHealth;
  ballX = width/4;
  ballY = height/5;
  lastAddTime = 0;
  walls.clear();
  gameScreen = 0;
}

void drawBall() {
  fill(ballColor);                            // Memberikan warna pada bola
  ellipse(ballX, ballY, ballSize, ballSize);  // Membuat bola
}

void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airFriction);
}

void makeBounceBottom(float surface) {
  ballY = surface - (ballSize / 2);
  ballSpeedVert *= -1;
  ballSpeedVert -= (ballSpeedVert * friction);
}

void makeBounceTop(float surface) {
  ballY = surface + (ballSize / 2);
  ballSpeedVert *= -1;
  ballSpeedVert -= (ballSpeedVert * friction);
}

// Menjaga bola tetap berada di layar
void keepInScreen() {
  // Jika bola menabrak bagian bawah layar
  if (ballY + (ballSize / 2) > height) {
    makeBounceBottom(height);
  }
  
  // Jika bola menabrak bagian atas layar
  if (ballY - (ballSize / 2) < 0) {
    makeBounceTop(0);
  }
  
  // Jika bola menabrak bagian kiri layar
  if (ballX - (ballSize / 2) < 0) {
    makeBounceLeft(0);
  }
  
  // Jika bola menabrak bagian kanan layar
  if (ballX + (ballSize / 2) > width) {
    makeBounceRight(width);
  }
}

void drawRacket() {
  fill(racketColor); // Mengisi warna raket
  rectMode(CENTER); // Mengatur perataan raket
  rect(mouseX, mouseY, racketWidth, racketHeight); // Mengatur posisi kotak berdasarkan posisi mouse
}

void watchRacketBounce() {
  float overhead = mouseY - pmouseY;
  if ((ballX + (ballSize / 2) > mouseX - (racketWidth / 2)) && (ballX - (ballSize / 2) < mouseX + (racketWidth / 2))) {
    if (dist(ballX, ballY, ballX, mouseY) <= (ballSize / 2) + abs(overhead)) {
      makeBounceBottom(mouseY);
      // Raket gerak naik
      if (overhead < 0) {
        ballY += overhead;
        ballSpeedVert += overhead;
      }
      ballSpeedHorizon = (ballX - mouseX) / 5;
    }
  }
}

void applyHorizontalSpeed() {
  ballX += ballSpeedHorizon;
  ballSpeedHorizon -= (ballSpeedHorizon * airFriction);
}

void makeBounceLeft(float surface) {
  ballX = surface + (ballSize / 2);
  ballSpeedHorizon *= -1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}

void makeBounceRight(float surface) {
  ballX = surface - (ballSize / 2);
  ballSpeedHorizon *= -1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}

void wallAdder() {
  if (millis() - lastAddTime > wallInterval) {
    int randHeight = round(random(minGapHeight, maxGapHeight));
    int randY = round(random(0, height - randHeight));
    
    int[] randWall = {width, randY, wallWidth, randHeight, 0};
    walls.add(randWall);
    lastAddTime = millis();
  }
}

void wallHandler() {
  for (int i = 0; i < walls.size(); i++) {
    wallRemover(i);
    wallMover(i);
    wallDrawer(i);
    watchWallCollision(i);
  }
}

void wallDrawer(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  // draw actual walls
  rectMode(CORNER);
  fill(wallColors);
  rect(gapWallX, 0, gapWallWidth, gapWallY, 0, 0, wallRadius, wallRadius);
  rect(gapWallX, gapWallY+gapWallHeight, gapWallWidth, height-(gapWallY+gapWallHeight), wallRadius, wallRadius, 0, 0);
}

void wallMover(int index) {
  int[] wall = walls.get(index);
  wall[0] -= wallSpeed;
}

void wallRemover(int index) {
  int[] wall = walls.get(index);
  if (wall[0] + wall[2] <= 0) {
    walls.remove(index);
  }
}

void watchWallCollision(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  int wallScored = wall[4];
  int wallTopX = gapWallX;
  int wallTopY = 0;
  int wallTopWidth = gapWallWidth;
  int wallTopHeight = gapWallY;
  int wallBottomX = gapWallX;
  int wallBottomY = gapWallY + gapWallHeight;
  int wallBottomWidth = gapWallWidth;
  int wallBottomHeight = height - (gapWallY + gapWallHeight);
  
  if (
    (ballX + (ballSize/2) > wallTopX) &&
    (ballX - (ballSize/2) < wallTopX + wallTopWidth) &&
    (ballY + (ballSize/2) > wallTopY) &&
    (ballY - (ballSize/2) < wallTopY + wallTopHeight)
    ) {
      decreaseHealth();
    }
    
  if (
  (ballX + (ballSize/2) > wallBottomX) &&
  (ballX - (ballSize/2) < wallBottomX + wallBottomWidth) &&
  (ballY + (ballSize/2) > wallBottomY) &&
  (ballY - (ballSize/2) < wallBottomY + wallBottomHeight)
  ) {
    decreaseHealth();
  }
  
  if (ballX > gapWallX + (gapWallWidth/2) && wallScored == 0) {
    wallScored = 1;
    wall[4] = 1;
    score();
  }
}

void drawHealthBar() {
  noStroke(); // Tanpa Border
  fill(236, 240, 241);
  rectMode(CORNER);
  rect(ballX - (healthBarWidth/2), ballY - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(ballX - (healthBarWidth/2), ballY - 30, healthBarWidth * (health/maxHealth), 5);
}

void decreaseHealth() {
  health -= healthDecrease;
  if (health <= 0) {
    gameOver();
  }
}

void gameOverScreen() {
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(30);
  text("Game Over", height/2, width/2 - 20);
  textSize(15);
  text("Click to Restart", height/2, width/2 + 10);
  printScore();
}

void score() {
  score++;
}

void printScore() {
  textAlign(CENTER);
  if (gameScreen == 1) {
    fill(0);
    textSize(30);
    text(score, height/2, width/2 - 100);
  } else if (gameScreen == 2) {
    fill(255);
    textSize(30);
    text("Score: " + score, height/2, width/2 + 80);
  }
}