class ArrayList extends Array {
    constructor() {
        super(...[]);
    }
    size() {
        return this.length;
    }
    add(x) {
        this.push(x);
    }
    get(i) {
        return this[i];
    }
    remove(i) {
        this.splice(i, 1);
    }
}

// Variabel Global
// 0: Initial Screen
// 1: Game Screen
// 2: Game-over Screen
let ballX, ballY;
let ballSize = 20;
let ballColor = color(0);
let gravity = 1;
let ballSpeedVert = 0;
let airFriction = 0.0001;
let friction = 0.1;
let racketColor = color(0);
let racketWidth = 100;
let racketHeight = 10;
let racketBounceRate = 20;
let wallSpeed = 5;
let wallInterval = 1000;
let lastAddTime = 0;
let minGapHeight = 200;
let maxGapHeight = 300;
let wallWidth = 80;
let wallColors = color(255, 0, 0);
let walls = new ArrayList();
let score = 0;
let wallRadius = 50;
let maxHealth = 100;
let health = 100;
let healthDecrease = 1;
let healthBarWidth = 60;
let ballSpeedHorizon = 10;
let gameScreen = 0;
function setup() {
    createCanvas(500, 500);
    ballX = width / 4;
    ballY = height / 5;
}
function draw() {
    if (gameScreen == 0) {
        initScreen();
    } else if (gameScreen == 1) {
        gameScreen();
    } else if (gameScreen == 2) {
        gameOverScreen();
    }
}
function gameOver() {
    gameScreen = 2;
} // SCREEN CONTENTS
function initScreen() {
    background(0);
    textAlign(CENTER);
    text("press play", height / 2, width / 2);
}
function gameScreen() {
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
} // INPUTS
function mousePressed() {
    // Jika pemain mengklik layar awal maka game dimulai
    if (gameScreen == 0) {
        startGame();
    } else if (gameScreen == 2) {
        restart();
    }
} // Metode ini mengatur variabel-variabel yang diperlukan untuk memulai game
function startGame() {
    gameScreen = 1;
}
function restart() {
    score = 0;
    health = maxHealth;
    ballX = width / 4;
    ballY = height / 5;
    lastAddTime = 0;
    walls.clear();
    gameScreen = 0;
}
function drawBall() {
    fill(ballColor); // Memberikan warna pada bola
    ellipse(ballX, ballY, ballSize, ballSize); // Membuat bola
}
function applyGravity() {
    ballSpeedVert += gravity;
    ballY += ballSpeedVert;
    ballSpeedVert -= ballSpeedVert * airFriction;
}
function makeBounceBottom(surface) {
    ballY = surface - ballSize / 2;
    ballSpeedVert *= -1;
    ballSpeedVert -= ballSpeedVert * friction;
}
function makeBounceTop(surface) {
    ballY = surface + ballSize / 2;
    ballSpeedVert *= -1;
    ballSpeedVert -= ballSpeedVert * friction;
} // Menjaga bola tetap berada di layar
function keepInScreen() {
    // Jika bola menabrak bagian bawah layar
    if (ballY + ballSize / 2 > height) {
        makeBounceBottom(height);
    } // Jika bola menabrak bagian atas layar
    if (ballY - ballSize / 2 < 0) {
        makeBounceTop(0);
    } // Jika bola menabrak bagian kiri layar
    if (ballX - ballSize / 2 < 0) {
        makeBounceLeft(0);
    } // Jika bola menabrak bagian kanan layar
    if (ballX + ballSize / 2 > width) {
        makeBounceRight(width);
    }
}
function drawRacket() {
    fill(racketColor); // Mengisi warna raket
    rectMode(CENTER); // Mengatur perataan raket
    rect(mouseX, mouseY, racketWidth, racketHeight); // Mengatur posisi kotak berdasarkan posisi mouse
}
function watchRacketBounce() {
    let overhead = mouseY - pmouseY;
    if (
        ballX + ballSize / 2 > mouseX - racketWidth / 2 &&
        ballX - ballSize / 2 < mouseX + racketWidth / 2
    ) {
        if (dist(ballX, ballY, ballX, mouseY) <= ballSize / 2 + abs(overhead)) {
            makeBounceBottom(mouseY); // Raket gerak naik
            if (overhead < 0) {
                ballY += overhead;
                ballSpeedVert += overhead;
            }
            ballSpeedHorizon = (ballX - mouseX) / 5;
        }
    }
}
function applyHorizontalSpeed() {
    ballX += ballSpeedHorizon;
    ballSpeedHorizon -= ballSpeedHorizon * airFriction;
}
function makeBounceLeft(surface) {
    ballX = surface + ballSize / 2;
    ballSpeedHorizon *= -1;
    ballSpeedHorizon -= ballSpeedHorizon * friction;
}
function makeBounceRight(surface) {
    ballX = surface - ballSize / 2;
    ballSpeedHorizon *= -1;
    ballSpeedHorizon -= ballSpeedHorizon * friction;
}
function wallAdder() {
    if (millis() - lastAddTime > wallInterval) {
        let randHeight = round(random(minGapHeight, maxGapHeight));
        let randY = round(random(0, height - randHeight));
        let randWall = [width, randY, wallWidth, randHeight, 0];
        walls.add(randWall);
        lastAddTime = millis();
    }
}
function wallHandler() {
    for (let i = 0; i < walls.size(); i++) {
        wallRemover(i);
        wallMover(i);
        wallDrawer(i);
        watchWallCollision(i);
    }
}
function wallDrawer(index) {
    let wall = walls.get(index); // get gap wall settings
    let gapWallX = wall[0];
    let gapWallY = wall[1];
    let gapWallWidth = wall[2];
    let gapWallHeight = wall[3]; // draw actual walls
    rectMode(CORNER);
    fill(wallColors);
    rect(gapWallX, 0, gapWallWidth, gapWallY, 0, 0, wallRadius, wallRadius);
    rect(
        gapWallX,
        gapWallY + gapWallHeight,
        gapWallWidth,
        height - (gapWallY + gapWallHeight),
        wallRadius,
        wallRadius,
        0,
        0
    );
}
function wallMover(index) {
    let wall = walls.get(index);
    wall[0] -= wallSpeed;
}
function wallRemover(index) {
    let wall = walls.get(index);
    if (wall[0] + wall[2] <= 0) {
        walls.remove(index);
    }
}
function watchWallCollision(index) {
    let wall = walls.get(index); // get gap wall settings
    let gapWallX = wall[0];
    let gapWallY = wall[1];
    let gapWallWidth = wall[2];
    let gapWallHeight = wall[3];
    let wallScored = wall[4];
    let wallTopX = gapWallX;
    let wallTopY = 0;
    let wallTopWidth = gapWallWidth;
    let wallTopHeight = gapWallY;
    let wallBottomX = gapWallX;
    let wallBottomY = gapWallY + gapWallHeight;
    let wallBottomWidth = gapWallWidth;
    let wallBottomHeight = height - (gapWallY + gapWallHeight);
    if (
        ballX + ballSize / 2 > wallTopX &&
        ballX - ballSize / 2 < wallTopX + wallTopWidth &&
        ballY + ballSize / 2 > wallTopY &&
        ballY - ballSize / 2 < wallTopY + wallTopHeight
    ) {
        decreaseHealth();
    }
    if (
        ballX + ballSize / 2 > wallBottomX &&
        ballX - ballSize / 2 < wallBottomX + wallBottomWidth &&
        ballY + ballSize / 2 > wallBottomY &&
        ballY - ballSize / 2 < wallBottomY + wallBottomHeight
    ) {
        decreaseHealth();
    }
    if (ballX > gapWallX + gapWallWidth / 2 && wallScored == 0) {
        wallScored = 1;
        wall[4] = 1;
        score();
    }
}
function drawHealthBar() {
    noStroke(); // Tanpa Border
    fill(236, 240, 241);
    rectMode(CORNER);
    rect(ballX - healthBarWidth / 2, ballY - 30, healthBarWidth, 5);
    if (health > 60) {
        fill(46, 204, 113);
    } else if (health > 30) {
        fill(230, 126, 34);
    } else {
        fill(231, 76, 60);
    }
    rectMode(CORNER);
    rect(
        ballX - healthBarWidth / 2,
        ballY - 30,
        healthBarWidth * (health / maxHealth),
        5
    );
}
function decreaseHealth() {
    health -= healthDecrease;
    if (health <= 0) {
        gameOver();
    }
}
function gameOverScreen() {
    background(0);
    textAlign(CENTER);
    fill(255);
    textSize(30);
    text("Game Over", height / 2, width / 2 - 20);
    textSize(15);
    text("Click to Restart", height / 2, width / 2 + 10);
    printScore();
}
function score() {
    score++;
}
function printScore() {
    textAlign(CENTER);
    if (gameScreen == 1) {
        fill(0);
        textSize(30);
        text(score, height / 2, width / 2 - 100);
    } else if (gameScreen == 2) {
        fill(255);
        textSize(30);
        text("Score: " + score, height / 2, width / 2 + 80);
    }
}
