PShape sh;
int tsz = 24; 
String fname = "picture.svg";
float rot = PI * -0.5;
int w = 1024;
int h = 1024;
int inc = 250;
int cursorsz = 5;
PVector p1p;
PVector p2p;
PVector p1xy;
PVector p2xy;
boolean p1sel;
boolean p2sel;

void settings(){
  size(w,h);  
}
PVector poltocar(PVector rtheta){
  return new PVector(rtheta.x * cos(rtheta.y), rtheta.x * sin(rtheta.y));
}

PVector cartopol(PVector xy){
  return new PVector(sqrt(pow(xy.x, 2.0) + pow(xy.y, 2.0)), (atan2(xy.y, xy.x) + TWO_PI) % TWO_PI);
}

void setup(){

  sh = loadShape(fname);
  textSize(tsz);
  textAlign(LEFT, TOP);
  p1sel = false;
  p2sel = false;
  p1p = new PVector(0., 0.);
  p2p = new PVector(0., 0.);
  p1xy = new PVector(0., 0.);
  p2xy = new PVector(0., 0.);
}


String[] p_str(PVector cur, String pfix, float mrad, float mtheta){
  float dr1 = mrad - cur.x;
  float dt1 = mtheta - cur.y;
  String cur_r = "rad: " + nf(cur.x, 0, 4);
  String cur_t = "theta: " + nf(cur.y, 0, 4);
  String d_r = "";
  String d_t = "";
  String[] ret = new String[2];
  if(dt1 > PI) dt1 -= TWO_PI;
  if(dt1 < -PI) dt1 += TWO_PI;
  d_r = "distrad: " + nf(dr1, 0 , 4);
  d_t = "distang: " + nf(dt1, 0, 4);
  ret[0] = pfix + " " + cur_r + " " + d_r;
  ret[1] = cur_t + " " + d_t;
  return ret;

}

void drawpt(PVector cur, int r, int g, int b){
  int cx1 = max(0, (int) min(cur.x-cursorsz, w));
  int cx2 = max(0, (int) min(cur.x+cursorsz, w));
  int cy1 = max(0, (int) min(cur.y-cursorsz, h));
  int cy2 = max(0, (int) min(cur.y+cursorsz, h));
  strokeWeight(3);
  stroke(r,g,b);
  line(cx1, cy1, cx2, cy2);
  line(cx2, cy1, cx1, cy2);
}

void draw(){
  int cx1 = max(0, min(mouseX-cursorsz, w));
  int cx2 = max(0, min(mouseX+cursorsz, w));
  int cy1 = max(0, min(mouseY-cursorsz, h));
  int cy2 = max(0, min(mouseY+cursorsz, h));
  int nx = mouseX - w/2;
  int ny = mouseY - h/2;
  float rad = sqrt(pow(nx, 2.0) + pow(ny, 2.0));
  float theta = (atan2(ny, nx) + TWO_PI) % TWO_PI;
  PVector mp = new PVector(max(w,h), atan2(ny,nx));
  PVector mxy = poltocar(mp);
  String rp = "rad: " + nf(rad, 0, 4);
  String tp = "ang: " + nf(theta, 0, 4);
  String[] s1 = p_str(p1p, "p1", rad, theta); 
  String[] s2 = p_str(p2p, "p2", rad, theta); 
  background(255);
  pushMatrix();
  translate(w/2, h/2);
  rotate(rot);
  shape(sh, -w/2,-h/2, w,h);
  popMatrix();
  fill(255,0,255);
  strokeWeight(1);
  stroke(150,150,150);
  circle(w/2, h/2, 5);
  for(int r = 0; r < w; r+= inc){
      noFill();
      circle(w/2, h/2, r);
  };
  line(w/2,0, w/2,h);
  line(0,h/2,w,h/2);
  strokeWeight(5);
  fill(0,255,255);
  line(cx1, cy1, cx2, cy2);
  line(cx2, cy1, cx1, cy2);
  
  fill(0,0,0);
  text(rp, 10, 0);
  text(tp, 10, int(tsz * 1.5));
  fill(175,175,50);
  if(p1sel == true) drawpt(p1xy, 175, 175, 50);
  text(s1[0], 10, int(tsz * 3.0));
  text(s1[1], 10, int(tsz * 4.5));
  fill(50,175,175);
  if(p2sel == true) drawpt(p2xy, 50, 175, 175);
  text(s2[0], 10, int(tsz * 6.0));
  text(s2[1], 10, int(tsz * 7.5));
  stroke(200,0,200);
  strokeWeight(1);
  pushMatrix();
  translate(w/2,h/2);
  line(0,0,max(-w, min(w,mxy.x)),max(-h, min(h, mxy.y)));
  popMatrix();
  //line(mouseX,0,mouseX,h);
  //line(0,mouseY, w,mouseY);
}

void keyPressed(){
  float kx = (float) mouseX;
  float ky = (float) mouseY;
  PVector kxy = new PVector(kx - (w/2.0), ky-(h/2.0));
  PVector kp = cartopol(kxy);
  if(key == '1'){
    p1sel = true;
    p1p.x = kp.x;
    p1p.y = kp.y;
    p1xy.x = kx;
    p1xy.y = ky;
  }
  else if(key == '2'){
    p2sel = true;
    p2p.x = kp.x;
    p2p.y = kp.y;
    p2xy.x = kx;
    p2xy.y = ky;
  };
  
}
