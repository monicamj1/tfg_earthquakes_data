class MapKey {
  color orange, red, c1, c2, c3, blue, blue2;
  float wP, hP, corner, rad, xPos, yPos, xPos2, yPos2;
  PVector e1, e2, e3, e4;
  
  MapKey(){
    orange = color(255, 204, 102);
    red = color(255, 102, 102);
    c1 = lerpColor(orange, red, 0.35);
    c2 = lerpColor(orange, red, 0.5);
    c3 = lerpColor(orange, red, 0.65);
    blue = color(51,177,255);
    blue2 = color(197,228,255);
    
    wP = width*0.25;
    hP = height*0.22;
    corner = width*0.015;
    rad = width*0.02;
    xPos = width*0.041;
    yPos = height*0.058;
    xPos2 = width*0.156;
    yPos2 = height*0.15;
    
    e1 = new PVector(width*0.11,height*0.09);
    e2 = new PVector(width*0.14,height*0.09);
    e3 = new PVector(width*0.17,height*0.09);
    e4 = new PVector(width*0.20,height*0.09);
  }
  
  void displayButton(){
    
    dropShadow(true);
    noStroke();
    fill(blue);
    ellipseMode(CENTER);
    ellipse(xPos,yPos,rad, rad);
    fill(255);
    textAlign(CENTER,CENTER);
    textSize(height*0.020);
    text("i",xPos-width*0.0002,yPos-height*0.002);    
  }
  
  void displayKey(){
    rectMode(CENTER);
    dropShadow(false);
    noStroke();
    fill(255);
    rect(xPos2,yPos2,wP,hP,corner);
    
    //first row
    ellipseMode(CENTER);
    fill(orange);
    ellipse(e1.x,e1.y,rad,rad);
    fill(c1);
    ellipse(e2.x,e2.y,rad,rad);
    fill(c3);
    ellipse(e3.x,e3.y,rad,rad);
    fill(red);
    ellipse(e4.x,e4.y,rad,rad);
    
    textSize(height*0.014);
    fill(blue);
    text("magnitude -", e1.x-width*0.044, e1.y-height*0.002);
    text("+ magnitude", e4.x+width*0.044, e4.y-height*0.002);
    
    
    //first row
    ellipseMode(CENTER);
    fill(c2);
    ellipse(e1.x,e1.y+height*0.05,width*0.02,width*0.02);
    ellipse(e2.x,e2.y+height*0.05,width*0.015,width*0.015);
    ellipse(e3.x,e3.y+height*0.05,width*0.01,width*0.01);
    ellipse(e4.x,e4.y+height*0.05,width*0.005,width*0.005);
    
    fill(blue);
    text("depth -", e1.x-width*0.034, e1.y+height*0.047);
    text("+ depth", e4.x+width*0.034, e4.y+height*0.047);
    
    //third row
    fill(blue);
    text("Zoom: Scroll", width*0.155, e1.y+height*0.095);
    text("Move around: click and drag", width*0.158, e4.y+height*0.13);
    
 
    fill(blue2);
    textSize(height*0.03);
    text("x", xPos, yPos-height*0.005);

    
  
    
    
    
    
  }
  
  void dropShadow(boolean b){
    float aux = rad;
    float wAux = wP;
    float hAux = hP;
    ellipseMode(CENTER);
    for (int i=10; i>=0; i-=1) {
      fill(100, 100, 100, i);
      noStroke();
      if(b){
      ellipse(xPos, yPos, aux, aux);
      }else{
        rect(xPos2,yPos2,wAux,hAux,corner); 
      }
      aux += aux*0.04;
      wAux += wAux*0.01;
      hAux += hAux*0.01;
    }
    
    
  }
  
  
  
  
}
