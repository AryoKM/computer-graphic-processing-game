// Variabel Global
// 0: Initial Screen
// 1: Game Screen
// 2: Game Over Screen

int gameScreen=0;
int ballX, ballY; // posisi bola
int ballSize=20; // ukuran bola
int ballColor=color(255, 0, 0); // warna bola
float gravity=1; // gaya gravitasi
float ballSpeedVert=0; // kecepatan bola di sumbu Y
float airfriction=0.0001; // gesekan udara
float friction=0.1;
color racketColor = color(0); // warna raket
float racketWidth=100; // lebar raket
float racketHeight=10; // tinggi raket
int racketBounceRate=20; //atur rate pantulan raket


void setup() {
  size(500, 500);
  ballX=width/4; // posisi awal bola di sumbu X
  ballY=height/5; // posisi awal bola di sumbu Y
}

// Tampilkan konten dari layar yang aktif
void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}

// SREEN CONTENTS
void initScreen() {
 // codes of initial screen 
 background(0);
 textAlign(CENTER);
 text("Click to Start the Game", width/2, height/2);
}

void gameScreen() {
 // codes of game screen 
 background(255);
 drawBall();
 applyGravity();
 keepInScreen();
 drawRacket();
 watchRacketBounce();
}

void gameOverScreen() {
 // codes of game over screen 
}

// INPUTS
public voide mousePressed() {
  // if player clicks the screen then the game will start
  if (gameScreen == 0) {
    startGame();
  }
}

// this method will manage the variables needed to start game
void startGame() {
  gameScreen = 1;
}

void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airfriction);
}

void makeBounceBottom(float, surface) {
    ballY = surface - (ballSize/2);
    ballSpeedVert *= -1; // mengurangi kecepatan setelah pantulan
    ballSpeedVert -= (ballSpeedVert * friction);
}

void makeBounceTop() {
    ballY = surface + (ballSize/2);
    ballSpeedVert *= -1; // mengurangi kecepatan setelah pantulan
    ballSpeedVert -= (ballSpeedVert * friction);
}

void keepInScreen() {
  if (ballY + (ballSize/2) >= height) {
    makeBounceBottom(height);
  }
  if (ballY - (ballSize/2) <= 0) {
    makeBounceTop(0);
  }
}

void drawRacket() {
  fill(racketColor);
  rectMode(CENTER);
  rect(mouseX, mouseY, racketWidth, racketHeight);
}

void watchRacketBounce() {
  float overhead = mouseY - pmouseY;
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-))
}

