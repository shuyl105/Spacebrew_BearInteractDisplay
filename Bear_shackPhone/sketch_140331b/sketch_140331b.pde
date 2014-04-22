import processing.video.*;
Movie stage1;
Movie stage3;

PImage img;

void setup(){
  size(800, 500);
  frameRate(30);
  img = loadImage("black.jpg");
  
  stage1 = new Movie(this, "stage1.flv");
  stage3 = new Movie(this, "stage3.flv");
//  stage1.loop();
  stage1.play();
  stage3.play();  
  img.mask(stage1);
}
void draw(){
  image(img, 0, 0, 500, 500);
  play1();
//  fill(0, 255, 0);//GREEN
//  rect(100, 100, 100, 100);
}

void play1() {
  image(stage1, 0, 0, width, height);
//  image(stage3, 0, 0, width, height);
}

void movieEvent(Movie myMovie) {
  myMovie.read();
}
