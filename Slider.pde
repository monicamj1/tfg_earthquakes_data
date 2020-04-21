class Slider {
  int[] yearList;
  int firstYear;
  int lastYear;
  PVector[] posList;
  PVector firstPos;
  PVector lastPos;
  float w1 = width*0.10, w2 = width*0.90, y = height*0.95, step, h=height*0.005;
  int selected;
  boolean pressed;
  float actualX;
  color c1, c2, c3;

  Slider(IntList years) {
    yearList = new int[years.size()];
    for (int i=0; i<yearList.length; i++) {
      yearList[i] = years.get(i);
    }
    firstYear = yearList[0];
    lastYear = yearList[yearList.length-1];

    firstPos = new PVector (w1, y);
    lastPos = new PVector (w2, y);

    posList = new PVector[years.size()];

    float barWidth = width-w1*2;
    step = barWidth/(posList.length-1);
    float w = w1;

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
  }

  void update(float posX) {
    //limit pos x max y min
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
