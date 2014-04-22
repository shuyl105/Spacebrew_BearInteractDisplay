//video
import processing.video.*;
Movie stage1;
Movie stage2;
Movie stage3;

// Spacebrew
import spacebrew.*;
String server = "sandbox.spacebrew.cc";
String name="wakeUpApp";
String desc = "Receiver; wake the bear up";
Spacebrew sb;

// info to receive from web app
int remote_sliderX_val;
int remote_sliderY_val;
int engaged_count=0;

// variables 
int called = 0;
int count = 0;
boolean playing;
boolean stage2Finished, refresh;
int time;
int wait2 = 5000;
int wait3 = 5000;
color colorInfo;

ArrayList<JSONObject> connectedClients;
JSONObject clients;


void setup() {
  size(800, 500);
//  background(255, 0 ,0);
  rectMode(CENTER);
  noStroke();
  frameRate(30);
  playing = false;
  stage2Finished = false;
  refresh = false;
  time = millis();
  

  stage1 = new Movie(this, "stage1.mp4");
  stage2 = new Movie(this, "stage2.mp4");
  stage3 = new Movie(this, "stage3.mp4");

  sb = new Spacebrew( this );

  //publish>>send
  //  sb.addPublish(colorInfo);
  //subscribe>>receive
  sb.addSubscribe( "remote_sliderX", "range" );
  sb.addSubscribe( "remote_sliderY", "range" );
  sb.addSubscribe("info", "guest");
  //sb.addPublish("");
  


  sb.connect( server, name, desc );
}

void draw() {
  // println("how many people"+ engaged_count);

/************ X event **************/
  if (remote_sliderX_val == -10 && !playing || remote_sliderX_val == 10 && !playing) {
    count ++;
  }
  
  if (refresh) {
    if (called == 0) {
      time = millis();
      //      println("---- pausing time ----");
    }
    called++;
    if (millis() - time < 10000) {
      //background(255);
    }
    else if (millis() - time >= 10000) {
      count = 0;
      refresh = false;
      playing = false;
      stage2Finished = false;
      called = 0;
    }
  }
  else if (count>=0 && count < 50
    || stage2Finished == true && count >= 50 && count <100
    || refresh == true && count >= 100 && count < 150) {//bear stage1
//    background(255, 0, 0);
    play1();
    fill(0);
    //text("sleeping........", 100,100);
  }
  else if (count >= 50 && count <100) {//stage2
    if (called == 0) {
      time = millis();
      stage2.jump(0);
      //      println("stage 2 !!!!!");
    }
    called++;
    if (millis() - time < wait2) {
      //        println("playing 2");
      play2();
    }
    else if (millis() - time >= wait2) {
      stage2Finished = true;
      playing = false;
      called = 0;
    }
  }
  else if (count >= 100 && count < 150) {//stage3
    if (called == 0) {
      time = millis();
      stage3.jump(0.1);
      //      println("stage 3 !!!!!");
    }
    called++;
    if (millis() - time < wait3) {
      //      println("playing 3");
      play3();
    }
    else if (millis() - time >= wait3) {    
      refresh = true;
      print("3rdStaredTime: "+ time + " ");
      print("RefreshingTime: "+ millis());
      println(refresh);
      called = 0;
    }
  }
//  println(count);
/************ Y event **************/
  if (remote_sliderY_val == -10 || remote_sliderY_val == 10) {
    fill(colorInfo);
    rect(100, 100, 100, 100);
  }
}

void play1() {
  stage1.loop();
  image(stage1, 0, 0, width, height);
}

void play2() {  
  playing = true;
  stage2.play();
  image(stage2, 0, 0, width, height);
}

void play3() {
  playing = true;
  stage3.play();
  image(stage3, 0, 0, width, height);
}

void onRangeMessage( String name, int value ) {
//  println("range");
//  println("got range message " + name + " : " + value);
  if (name.equals("remote_sliderX")) {
    //do x stuff
    println("rangeX");
    remote_sliderX_val = value;
  }
  if (name.equals("remote_sliderY")) {
    //do x stuff
    println("rangeY");
    remote_sliderY_val = value;
  }
}


void onCustomMessage( String name, String type, String value ) {
  if (name.equals("info")) {

      // do something!!

    if(value.equals("red")){
      colorInfo = color(255,0,0);
    }else if(value.equals("green")){
      colorInfo = color(0,255,0);
    }else if(value.equals("blue")){
      colorInfo = color(0,0,255);
    }
  }
//  println("engaging # : " + engaged_count);
}

void movieEvent(Movie myMovie) {
  myMovie.read();
}

