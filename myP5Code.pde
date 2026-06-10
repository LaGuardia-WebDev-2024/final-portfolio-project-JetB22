// ---------------------
// PLAYER
// ---------------------

int playerMaxHP = 45;
int playerHP = 45;
int playerAC = 16;

// ---------------------
// ENEMY
// ---------------------

String enemyName = "";
int enemyHP = 0;
int enemyMaxHP = 0;
int enemyAC = 0;
int enemyAttackDie = 0;
int enemyAttackBonus = 0;
boolean bossFight = false;

// ---------------------
// TURNS
// ---------------------

boolean playerTurn = true;
int enemyTurnTimer = 0;

// ---------------------
// PROGRESSION
// ---------------------

int fightsWon = 0;

// ---------------------
// GAME STATE
// ---------------------

boolean gameOver = false;
boolean gameWon = false;

int deathTimer = 0;

// ---------------------
// COMBAT LOG
// ---------------------

String[] combatLog = new String[6];

// =====================================================
// SETUP
// =====================================================

void setup() {

  size(750, 500);

  frameRate(60);

  resetToStart();
}

// =====================================================
// DRAW
// =====================================================

void draw() {

  background(15, 15, 20);

  drawScanlines();

  drawUI();

  if (gameWon) {
    return;
  }

  if (gameOver) {

    if (deathTimer > 0) {
      deathTimer--;
    }

    if (deathTimer == 0) {
      resetToStart();
    }

    return;
  }

  if (!playerTurn && enemyTurnTimer > 0) {

    enemyTurnTimer--;

    if (enemyTurnTimer == 0) {
      enemyAttack();
    }
  }

  // LOW HP WARNING FLASH

  if (
    playerHP > 0 &&
    playerHP <= playerMaxHP * 0.20 &&
    frameCount % 30 < 15
    ) {

    fill(255, 0, 0, 35);
    noStroke();
    rect(0, 0, width, height);
  }
}

// =====================================================
// UI
// =====================================================

void drawUI() {

  fill(255, 0, 255);

  textSize(16);
  text("FIGHTS WON: " + fightsWon, 315, 30);

  // PLAYER

  drawPlayerPanel();

  fill(255, 0, 255);

  textSize(18);
  text("PLAYER", 30, 85);

  drawHealthBar(
    30,
    100,
    260,
    20,
    playerHP,
    playerMaxHP
    );

  textSize(14);

  text(
    "HP: " +
    playerHP +
    "/" +
    playerMaxHP +
    "   AC: " +
    playerAC,
    30,
    140
    );

  // ENEMY

  drawEnemyPanel();

  fill(255, 0, 255);

  textSize(18);
  text(enemyName.toUpperCase(), 430, 85);

  drawHealthBar(
    430,
    100,
    260,
    20,
    enemyHP,
    enemyMaxHP
    );

  textSize(14);

  text(
    "HP: " +
    enemyHP +
    "/" +
    enemyMaxHP +
    "   AC: " +
    enemyAC,
    430,
    140
    );

  // COMMANDS

  fill(255, 0, 255);

  textSize(16);

  text("> COMMANDS", 20, 210);

  text("[1] DAGGER", 20, 235);
  text("[2] LONGSWORD", 20, 260);
  text("[3] HEAL", 20, 285);
  text("[4] FIREBOLT", 20, 310);
  text("[5] WARHAMMER", 20, 335);

  drawCombatLog();

  // GAME OVER

  if (gameOver) {

    fill(0, 0, 0, 220);
    rect(0, 0, width, height);

    fill(255, 50, 50);

    textAlign(CENTER, CENTER);

    textSize(48);
    text("GAME OVER", width/2, height/2 - 20);

    textSize(18);
    text(
      "PRESS R OR WAIT 5 SECONDS",
      width/2,
      height/2 + 30
      );

    textAlign(LEFT, BASELINE);
  }

  // WIN

  if (gameWon) {

    fill(0, 0, 0, 220);
    rect(0, 0, width, height);

    fill(0, 255, 100);

    textAlign(CENTER, CENTER);

    textSize(48);
    text("VICTORY", width/2, height/2 - 40);

    textSize(24);
    text(
      "THE DRAGON HAS FALLEN",
      width/2,
      height/2 + 10
      );

    textSize(16);
    text(
      "PRESS R TO PLAY AGAIN",
      width/2,
      height/2 + 60
      );

    textAlign(LEFT, BASELINE);
  }
}

// =====================================================
// PANELS
// =====================================================

void drawPanel(
  float x,
  float y,
  float w,
  float h
  ) {

  fill(10);

  stroke(255, 0, 255);
  strokeWeight(2);

  rect(x, y, w, h);

  strokeWeight(1);
  noStroke();
}

void drawPlayerPanel() {

  float hpPercent =
    (float)playerHP / playerMaxHP;

  if (hpPercent > 0.60) {

    stroke(255, 0, 255);

  } else if (hpPercent > 0.30) {

    stroke(255, 220, 0);

  } else {

    stroke(255, 50, 50);
  }

  fill(10);

  strokeWeight(2);

  rect(20, 60, 300, 120);

  strokeWeight(1);

  noStroke();
}

void drawEnemyPanel() {

  float hpPercent = 1;

  if (enemyMaxHP > 0) {
    hpPercent =
      (float)enemyHP / enemyMaxHP;
  }

  if (hpPercent > 0.60) {

    stroke(255, 0, 255);

  } else if (hpPercent > 0.30) {

    stroke(255, 220, 0);

  } else {

    stroke(255, 50, 50);
  }

  fill(10);

  strokeWeight(2);

  rect(420, 60, 300, 120);

  strokeWeight(1);

  noStroke();
}

// =====================================================
// HEALTH BAR
// =====================================================

void drawHealthBar(
  float x,
  float y,
  float w,
  float h,
  int current,
  int maxHP
  ) {

  float percent =
    constrain(
    (float)current / maxHP,
    0,
    1
    );

  stroke(100, 205, 100);

  fill(0);

  rect(
    x,
    y,
    w,
    h
    );

  if (percent > 0.60) {

    fill(0, 255, 0);

  } else if (percent > 0.30) {

    fill(255, 220, 0);

  } else {

    fill(255, 50, 50);
  }

  rect(
    x,
    y,
    w * percent,
    h
    );

  noStroke();
}

// =====================================================
// SCANLINES
// =====================================================

void drawScanlines() {

  stroke(255, 20);

  for (int y = 0; y < height; y += 3) {

    line(
      0,
      y,
      width,
      y
      );
  }

  noStroke();
}

// =====================================================
// COMBAT LOG
// =====================================================

void drawCombatLog() {

  drawPanel(
    20,
    340,
    700,
    140
    );

  fill(255, 0, 255);

  textSize(14);

  text(
    "COMBAT LOG:",
    30,
    360
    );

  for (
    int i = 0;
    i < combatLog.length;
    i++
    ) {

    if (combatLog[i] != null) {

      text(
        combatLog[i],
        30,
        385 + i * 18
        );
    }
  }
}

void addLog(String message) {

  if (message.length() > 55) {

    message =
      message.substring(0, 52)
      + "...";
  }

  for (
    int i = combatLog.length - 1;
    i > 0;
    i--
    ) {

    combatLog[i] =
      combatLog[i - 1];
  }

  combatLog[0] =
    message;
}

// =====================================================
// INPUT
// =====================================================

void keyPressed() {

  if (
    (gameWon || gameOver) &&
    (key == 'r' || key == 'R')
    ) {

    resetToStart();
    return;
  }

  if (gameWon) return;
  if (gameOver) return;
  if (!playerTurn) return;

  if (key == '1') {
    playerAttack("DAGGER", 4, 8);
  }

  if (key == '2') {
    playerAttack("LONGSWORD", 6, 7);
  }

  if (key == '3') {
    healPlayer();
  }

  if (key == '4') {
    playerAttack("FIREBOLT", 10, 6);
  }

  if (key == '5') {
    playerAttack("WARHAMMER", 12, 5);
  }

  if (key == '0') {

    enemyHP -= 100;

    addLog("> DISCOMBOBULATE");

    endPlayerTurn();
  }
}

// =====================================================
// PLAYER ATTACK
// =====================================================

void playerAttack(
  String name,
  int die,
  int bonus
  ) {

  int d20 =
    int(random(1, 21));

  int total =
    d20 + bonus;

  if (
    d20 == 20 ||
    total >= enemyAC
    ) {

    int damage =
      int(random(
      1,
      die + 1
      ));

    if (d20 == 20) {

      damage *= 2;

      addLog(
        "> CRITICAL HIT!"
        );
    }

    enemyHP -= damage;

    addLog(
      "> " +
      name +
      " HITS FOR " +
      damage
      );
  } else {

    addLog(
      "> " +
      name +
      " MISSES"
      );
  }

  endPlayerTurn();
}

// =====================================================
// HEAL
// =====================================================

void healPlayer() {

  int healRoll =
    int(random(1, 13));

  int healAmount =
    healRoll;

  if (healRoll == 12) {

    healAmount *= 2;

    addLog(
      "> CRITICAL HEAL +" +
      healAmount
      );
  } else {

    addLog(
      "> HEAL +" +
      healAmount
      );
  }

  playerHP += healAmount;

  if (playerHP > playerMaxHP) {
    playerHP = playerMaxHP;
  }

  endPlayerTurn();
}

// =====================================================
// TURN END
// =====================================================

void endPlayerTurn() {

  if (enemyHP <= 0) {

    fightsWon++;

    addLog(
      "> " +
      enemyName.toUpperCase() +
      " DEFEATED"
      );

    if (bossFight) {

      gameWon = true;
      return;
    }

    pickEnemy();

    addLog(
      "> ENCOUNTER: " +
      enemyName.toUpperCase()
      );

    return;
  }

  playerTurn = false;

  enemyTurnTimer = 60;
}

// =====================================================
// ENEMY TURN
// =====================================================

void enemyAttack() {

  int d20 =
    int(random(1, 21));

  int total =
    d20 +
    enemyAttackBonus;

  if (
    d20 == 20 ||
    total >= playerAC
    ) {

    int damage =
      int(random(
      1,
      enemyAttackDie + 1
      ));

    if (d20 == 20) {

      damage *= 2;

      addLog(
        "> " +
        enemyName.toUpperCase() +
        " CRITICAL HIT!"
        );
    }

    playerHP -= damage;

    addLog(
      "> " +
      enemyName.toUpperCase() +
      " HITS FOR " +
      damage
      );
  } else {

    addLog(
      "> " +
      enemyName.toUpperCase() +
      " MISSES"
      );
  }

  if (playerHP <= 0) {

    playerHP = 0;

    gameOver = true;

    deathTimer = 300;

    return;
  }

  playerTurn = true;
}

// =====================================================
// ENEMY SPAWNING
// =====================================================

void pickEnemy() {

  if (
    fightsWon >= 3 &&
    !bossFight
    ) {

    spawnDragon();
    return;
  }

  bossFight = false;

  int choice =
    int(random(4));

  if (choice == 0) {

    enemyName = "Goblin";
    enemyMaxHP = 20;
    enemyAC = 11;
    enemyAttackDie = 6;
    enemyAttackBonus = 4;

  } else if (choice == 1) {

    enemyName = "Orc";
    enemyMaxHP = 28;
    enemyAC = 13;
    enemyAttackDie = 8;
    enemyAttackBonus = 5;

  } else if (choice == 2) {

    enemyName = "Troll";
    enemyMaxHP = 36;
    enemyAC = 14;
    enemyAttackDie = 10;
    enemyAttackBonus = 6;

  } else {

    enemyName = "Knight";
    enemyMaxHP = 30;
    enemyAC = 15;
    enemyAttackDie = 8;
    enemyAttackBonus = 8;
  }

  enemyHP =
    enemyMaxHP;

  playerTurn = true;
}

void spawnDragon() {

  bossFight = true;

  enemyName = "Dragon";

  enemyMaxHP = 60;
  enemyAC = 15;

  enemyAttackDie = 12;
  enemyAttackBonus = 4;

  enemyHP = enemyMaxHP;

  addLog("> WARNING");
  addLog("> DRAGON DETECTED");
}

// =====================================================
// RESET
// =====================================================

void resetToStart() {

  playerHP =
    playerMaxHP;

  playerTurn = true;

  enemyTurnTimer = 0;

  fightsWon = 0;

  bossFight = false;

  gameOver = false;
  gameWon = false;

  deathTimer = 0;

  for (
    int i = 0;
    i < combatLog.length;
    i++
    ) {

    combatLog[i] = null;
  }

  pickEnemy();

  addLog("> GAME STARTED");

  addLog(
    "> ENCOUNTER: " +
    enemyName.toUpperCase()
    );
}