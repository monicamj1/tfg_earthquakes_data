class Slider {
  int[] yearList;
  int firstYear;
  int lastYear;
  PVector[] posList;
  PVector firstPos;
  PVector lastPos;
  float w1, w2, y, step, h;
  int selected;
  boolean pressed;
  float actualX;
  color c1, c2, c3;

  Slider(IntList years) {
    yearList = new int[years.size()];
    for (int i=0; i<yearList.length; i++) {
      yearList[i] = years.get(i);
    }
    
    w1 = width*0.10; 
    w2 = width*0.90; 
    y = height*0.95;
    h = height*0.005; 
    
    firstPos = new PVector (w1, y);
    lastPos = new PVector (w2, y);
    
    firstYear = yearList[0];
    lastYear = yearList[yearList.length-1];

    posList = new PVector[years.size()];

    float barWidth = width-w1*2;
    step = barWidth/(posList.length-1);
    float w = w1; //set first x point

    for (int i=0; i<posList.length; i++) {
      posList[i] = new PVector (w, y);
      w = w+step;
    }

    c1 = color(255, 128, 167); 
    c2 = color(255, 102, 142); 
    c3 = color(255, 179, 210);

    selected = 0; 
    pressed = false; 
    actualX = posList[selected].x;
  }


  void display() {
    stroke(c1);
    strokeWeight(height*0.003);
    strokeCap(ROUND);
    line(firstPos.x, firstPos.y, lastPos.x, lastPos.y);

    for (int i=0; i<posList.length; i++) {
      PVector position = posList[i];
      line(position.x, position.y-h, position.x, position.y+h);
    }
    controller();
    limitYears();
    
  }

  void controller() {
    PVector conPos = new PVector(actualX, y);
    if (!pressed) {
      fill(c2);
      noStroke();
      ellipse(conPos.x, conPos.y, height*0.015, height*0.015);
      fill(c3);
      noStroke();
      ellipse(conPos.x, conPos.y, height*0.005, height*0.005);
    } else { 
      fill(c3);
      noStroke();
      ellipse(conPos.x, conPos.y, height*0.018, height*0.018);
      fill(c2);
      noStroke();
      ellipse(conPos.x, conPos.y, height*0.008, height*0.008);
    }
    rectMode(CENTER);
    fill(c2);
    rect(conPos.x, conPos.y-height*0.047, width*0.05, height*0.035, 500);
    textSize(height*0.020);
    textAlign(CENTER, CENTER);
    fill(255);
    //Use the selected year so it changes!!
    text(str(yearList[selected]), conPos.x, conPos.y-height*0.05);
  }
  
  void limitYears(){
    //draw the first and last years
    rectMode(CENTER);
    fill(c1);
    rect(firstPos.x-width*0.045, firstPos.y, width*0.05, height*0.035, 500);
    rect(lastPos.x+width*0.045, lastPos.y, width*0.05,  height*0.035, 200);
    
    textSize(height*0.020);
    textAlign(CENTER, CENTER); //horizontally and vertically
    fill(255);
    text(str(firstYear), firstPos.x-width*0.045, firstPos.y-height*0.002);
    text(str(lastYear), lastPos.x+width*0.045, lastPos.y-height*0.002);
  }

  void update(float posX) {
    for (int i=0; i<posList.length; i++) {
      if (posX < w1) {
        actualX = w1;
        selected = 0;
      } else if (posX > w2) {
        actualX = w2;
        selected = posList.length-1;
      } else if (posX > posList[i].x-step/2 && posX < posList[i].x+step/2) {
        actualX = posList[i].x;
        selected = i;
      }
    }
  }
}
