RThread[] thread = new RThread[10];
double maxIt = 200;

double midA = -0.5;//0.44357482009322663;//-1.76938317919551501821;
double midB = 0;//-0.3722051957647288;//0.00423684791873677221;
double zoom = 4;//1.4224597E-20;

boolean zooming = false;
boolean zoommode = true;
boolean pressed = false;
double mpx = 0, mpy = 0, spx = 0, spy = 0;

int res = 1;

void setup(){
  //size(1000,1000);
  fullScreen();
  colorMode(HSB);
}

void draw(){
  render();
  if(zooming) zoom *= 0.9;
  move();
}

void render(){
  loadPixels();
  for(int i = 0; i < thread.length; i ++) thread[i] = new RThread(maxIt);
  int tIndex = 0;
  for(double y = 0; y < height; y += res){
    for(double x = 0; x < width; x += res){
      thread[tIndex].addTask(x/width*zoom*((double)width/height)-(zoom/(2*(double)height/width))+midA,y/height*zoom-(zoom/2)+midB,(int)(y*width+x));
      tIndex = (tIndex+1)%thread.length;
    }
  }
  for(int i = 0; i < thread.length; i ++) thread[i].start();
  while(working()){}
  renderPixels();
  updatePixels();
}

boolean working(){
  boolean working = false;
  for(int i = 0; i < thread.length; i ++) if(thread[i].isAlive()) working = true;
  return working;
}

void renderPixels(){
  for(int i = 0; i < thread.length; i ++){
    for(Task t : thread[i].tasks){
      for(int j = 0; j < res*res; j ++) pixels[constrain(t.index+(j%res)+width*(j/res),0,pixels.length-1)] = (t.it == maxIt) ? color(0,0,0) : color((float)(t.it/maxIt*255),255,255);
    }
  }
}

void move(){
  if(mousePressed){
    if(!pressed){
      pressed = true;
      mpx = -((double)mouseX/width*zoom-(zoom/2));
      mpy = -((double)mouseY/height*zoom-(zoom/2));
      spx = midA;
      spy = midB;
    }if(pressed){
      midA = spx-((mpx+(double)mouseX/width*zoom-(zoom/2))*width/height);
      midB = spy-(mpy+(double)mouseY/height*zoom-(zoom/2));
    }
  }else pressed = false;
}

void mouseReleased(){
  pressed = false;
}

void keyPressed(){
  //should be a switch statement but im too lazy to even change those to else if
  if(key == ' ') zooming = !zooming;
  if(key == '+') maxIt = (int)(maxIt*1.5);
  if(key == '-') maxIt = constrain((int)(maxIt/1.5),2,(int)maxIt);
  if(key == '0') maxIt = 0;
  if(key == ','){println("midA: "+midA); println("midB: "+midB); println("Zoom: "+zoom); println("Max Iterations: "+maxIt);}
  if(key == 'z') zoommode = !zoommode;
  if(key == '*') res ++;
  if(key == '/') res = constrain((int)res-1,1,(int)res);
}

void mouseWheel(MouseEvent event){
  if(zoommode){
    midA += -event.getCount()*((double)mouseX/width*zoom-(zoom/2))/2*width/height;
    midB += -event.getCount()*((double)mouseY/height*zoom-(zoom/2))/2;
  }
  zoom *= pow(1/0.7,event.getCount());
}
