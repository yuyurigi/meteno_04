class Bebenomu { //<>//
  float x, y;
  int size;
  Meteno meteno;
  float n;
  float velx, vely;
  float xNoise;
  float strokeW = 1; //線の太さ
  color strokeC = color(0, 19, 27); //線の色
  color murasaki = color(227, 31, 65);
  color pink = color(351, 36, 99);
  color white = color(45, 7, 95);
  color mizuiro = color(195, 21, 95);
  float s; //スケール値
  float zure = 1; //色のずれ
  PShape[] bebes = new PShape[8];

  Bebenomu(float _x, float _y, int _size) {
    x = _x;
    y = _y;
    size = _size;
    shapeMode(CENTER);
    
    PShape bebenomuSvg = loadShape("bebenomu.svg");
    bebenomuSvg.disableStyle();
    for (int i = 0; i < bebes.length; i++) {
      String svgName = nf(i, 1);
      bebes[i] = bebenomuSvg.getChild(svgName);
    }
    
    meteno = new Meteno(0, 0, 0, size/2, 2);
    meteno.setRotate(radians(-20));
    meteno.setFace(0);
    vely = map(size/2, minSize, maxSize, minVel, maxVel);
    velx = 0;
    xNoise = 0.02;
    s = 0.01*size;
  }

  void move() {
    n = noise(velx)*15.0; //メテノが横に揺れ動く数値
    y -= vely;
    velx = velx + xNoise;

    if (y < 0 - size/2) {
      y = height + size/2;
      x = random(20, width-20);
    }
  }

  void display() {
    pushMatrix();
    translate(x+n, y);
    
    pushMatrix();
    scale(s);
    fill(0, 0, 99); //白色部分
    noStroke();
    shape(bebes[2], 0, 0);
    
    pushMatrix(); //色
    translate(0, 2);
    scale(0.95);
    fill(murasaki);
    shape(bebes[0], 0, 0);
    fill(pink);
    shape(bebes[1], 0, 0);
    popMatrix();
    
    noFill(); //ベベノム（下半身）線
    strokeWeight(1.0/s * strokeW);
    stroke(strokeC); //線
    shape(bebes[2], 0, 0);
    popMatrix();

    meteno.display();

    pushMatrix();
    scale(s);
    fill(0, 0, 99); //白色部分
    noStroke();
    shape(bebes[7], 0, 0);
    
    pushMatrix(); //色
    translate(zure, 0);
    scale(0.95);
    noStroke();
    fill(murasaki);
    shape(bebes[3], 0, 0);
    fill(pink);
    shape(bebes[4], 0, 0);
    fill(white);
    shape(bebes[5], 0, 0);
    fill(mizuiro);
    shape(bebes[6], 0, 0);
    popMatrix();

    noFill(); //線
    stroke(strokeC);
    shape(bebes[7], 0, 0);
    popMatrix();
    
    popMatrix();
  }
}
