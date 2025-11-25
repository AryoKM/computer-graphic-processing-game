// Variabel Global
// 0: Initial Screen
// 1: Game Screen
// 2: Game Over Screen

int gameScreen=0;

void setup() {
  size(500, 500);
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