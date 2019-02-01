class Meteno implements Comparable {
  float x, y;
  float vely;
  int size; //直径
  float n;
  float s; //スケール値
  float velx = 0;
  float xNoise;
  float ro; //回転
  color c1, c2, c3, c4; //メテノの色（濃い、中間、薄い、模様の色）
  color strokeC = color(0, 19, 27); //線の色
  int sb; //メテノの裏表
  PGraphics pg1, pg2; //マスク
  PGraphics pg3, pg4;
  float strokeW = 1.0; //線の太さ

  //コンストラクタ
  Meteno(float _x, float _y, float _vely, int _size, int _col) {
    x = _x;
    y = _y;
    vely = _vely;
    size = _size;
    if (size > 40) {
      xNoise = random(0.05); //横揺れ
    } else {
      xNoise = map(vely, minVel, maxVel, 0.001, 0.05); //サイズが40以下の小さいメテノはあまり揺れないようにする
    }
    ro = random(TWO_PI); //回転
    sb = int(random(2)); //メテノの裏表
    shapeMode(CENTER);
    imageMode(CENTER);
    metenoColor(_col);
    metenoMask();
    metenoMask2();
    s = 0.01*size;
  }

  void setRotate(float rot) { //回転設定
    ro = rot;
  }

  void setFace(int face) { //メテノの裏表設定,　0=表, 1=裏
    sb = face;
  }

  void move() {
    n = noise(velx)*15.0; //メテノが横に揺れ動く数値
    y -= vely;
    velx = velx + xNoise;

    if (y < 0 - size/2) {
      y = height + size/2;
      x = random(width);
    }
  }

  void display() {
    blendMode(BLEND);
    pushMatrix();
    translate(x+n, y);

    pushMatrix();
    rotate(ro);
    scale(s);
    fill(0, 0, 99);
    noStroke();
    shape(metenoSvg[0], 0, 0);
    popMatrix();

    pushMatrix();//メテノ色部分
    translate(1, 1); //色のずれ
    rotate(ro);
    scale(s);
    scale(0.95);
    if (size > 40) {
      image(pg1, 0, 0);
    } else {
      fill(c1); 
      noStroke();
      shape(metenoSvg[0], 0, 0);
    }
    popMatrix();
    
    scale(s);
    rotate(ro);

    if (size > 40) {
      blendMode(MULTIPLY);
      image(pg3, 0, 0);
    }

    blendMode(BLEND);
    strokeWeight((1.0 / s) * strokeW);
    noFill();
    stroke(strokeC); //メテノ輪郭
    shape(metenoSvg[0], 0, 0);

    if (sb == 0 && size > 40) { //表
      stroke(strokeC);
      fill(c2);
      shape(metenoSvg[1], 0, 0); //目
      fill(c3);
      shape(metenoSvg[3], 0, 0); //くち
      strokeWeight(1);
      strokeJoin(ROUND);
      stroke(c4);
      fill(c4);
      shape(metenoSvg[4], 0, 0); //模様
      fill(c3);
      noStroke();
      shape(metenoSvg[2], 0, 0); //白目
    } else if (sb == 1 && size > 40) { //裏
      strokeWeight(1);
      strokeJoin(ROUND);
      stroke(c4);
      fill(c4);
      shape(metenoSvg[5], 0, 0); //模様
    }

    popMatrix();
  }

  void metenoColor(int colorP) {
    switch(colorP) {
    case 0: //red
      c1 = color(7, 33, 99); //濃い色
      c2 = color(7, 20, 99); //中間色
      c3 = color(33, 3, 99); //薄い色
      c4 = color(353, 44, 96); //模様の色
      break;
    case 1: //yellow
      c1 = color(49, 53, 98); //濃い色
      c2 = color(38, 56, 97); //中間色
      c3 = color(34, 11, 99); //薄い色
      c4 = color(45, 89, 95); //模様の色
      break;
    case 2: //orange
      c1 = color(34, 67, 99); //濃い色
      c2 = color(30, 33, 98); //中間色
      c3 = color(50, 8, 94); //薄い色
      c4 = color(0, 44, 96); //模様の色
      break;
    case 3: //blue
      c1 = color(184, 28, 84); //濃い色
      c2 = color(184, 14, 84); //中間色
      c3 = color(184, 3, 93); //薄い色
      c4 = color(185, 29, 68); //模様の色
      break;
    case 4: //green
      c1 = color(60, 58, 89);
      c2 = color(55, 39, 96);
      c3 = color(16, 10, 98);
      c4 = color(60, 58, 69);
      break;
    case 5: //gray
      c1 = color(26, 7, 88);
      c2 = color(183, 31, 82);
      c3 = color(41, 7, 93);
      c4 = color(183, 21, 82);
      break;
    case 6: //purple
      c1 = color(329, 21, 82); //濃い色
      c2 = color(0, 20, 96); //中間色
      c3 = color(40, 1, 100); //薄い色
      c4 = color(325, 26, 76); //模様の色
      break;
    }
  } //metenoColor_end

  void metenoMask() { //メテノボディ
    pg1 = createGraphics(100, 100);
    pg2 = createGraphics(100, 100);

    pg1.beginDraw();
    pg1.background(c3);
    pg1.ellipseMode(CENTER);
    pg1.noStroke();
    pg1.fill(c2);
    pg1.ellipse(100/2, 100/2, 100*0.8, 100*0.8);
    pg1.fill(c1);
    pg1.ellipse(100/2, 100/2, 100*0.7, 100*0.7);
    pg1.endDraw();

    pg2.beginDraw();
    pg2.background(0);
    pg2.fill(255, 255, 255);
    //pg2.ellipse(size/2, size/2, size, size);
    pg2.shapeMode(CENTER);
    pg2.pushMatrix();
    pg2.translate(100/2, 100/2);
    pg2.scale(.01*100, .01*100);
    pg2.shape(metenoSvg[0], 0, 0);
    pg2.popMatrix();
    pg2.endDraw();

    pg1.mask(pg2);
  } //metenoMask_end

  void metenoMask2() { //メテノボディ線
    pg3 = createGraphics(100, 100);
    pg4 = createGraphics(100, 100);

    pg3.beginDraw();
    pg3.background(255);
    pg3.ellipseMode(CENTER);
    pg3.strokeWeight(strokeW);
    pg3.stroke(strokeC);
    pg3.ellipse(100/2, 100/2, 100*0.8, 100*0.8);
    pg3.ellipse(100/2, 100/2, 100*0.7, 100*0.7);
    pg3.endDraw();

    pg4.beginDraw();
    pg4.background(0);
    pg4.fill(255, 255, 255);
    pg4.shapeMode(CENTER);
    pg4.pushMatrix();
    pg4.translate(100/2, 100/2);
    pg4.scale(.01*100, .01*100);
    pg4.shape(metenoSvg[0], 0, 0);
    pg4.popMatrix();
    pg4.endDraw();

    pg3.mask(pg4);
  } //metenoMask2_end

  int compareTo(Object o) {
    Meteno m = (Meteno) o;
    return size-m.size;
  }
}
