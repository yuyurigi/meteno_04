class Starrysky {
  float x, y;
  float size;
  
  Starrysky(){
    x = random(width);
    y = random(height);
    size = random(2, 8);
  }
  
  void display(){
    noStroke();
    fill(0, 0, 99); //白
    ellipse(x, y, size, size);
  }
  
}
