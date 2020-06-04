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
    //factor that changes when is selected
    float add;
    if (!pressed) {
      add = 1; //dimensions won't change
    } else {
      add = 1.2; //dimensions will increase x1.2
    }
    //CONTROLLER
    //draw shadow first!
    dropShadow(conPos, height*0.015*add);
    fill(c2);
    noStroke();
    ellipse(conPos.x, conPos.y, height*0.015*add, height*0.015*add);
    fill(c3);
    noStroke();
    ellipse(conPos.x, conPos.y, height*0.005*add, height*0.005*add);
    //YEAR
    rectMode(CENTER);
    fill(c2);
    rect(conPos.x, conPos.y-height*0.047*add, width*0.05*add, height*0.035*add, 500);
    textSize(height*0.020*add);
    textAlign(CENTER, CENTER);
    fill(255);
    //Use the selected year so it changes
    text(str(yearList[selected]), conPos.x, conPos.y-height*0.05*add);
  }

  void dropShadow(PVector pos, float r) {
    float aux = r; //controller radius
    float w = width*0.05; //year rect width
    float h = height*0.035; //year rect height
    float j, f, f2; //grey color and factors
    if (!pressed) {
      //less difussion
      j = 5;
      f = 0.08;
      f2 = 0.02;
    } else {
      //more difussion when selected
      j = 100;
      f =0.1;
      f2 = 0.05;
    }
    for (int i=10; i>=0; i-=1) {
      fill(j, j, j, i);
      noStroke();
      ellipse(pos.x, pos.y, aux, aux);
      rectMode(CENTER);
      rect(pos.x, pos.y-height*0.047, w, h, 500);
      aux += aux*f;
      w += w*f2;
      h += h*f2;
    }
  }

  void limitYears() {
    //draw the first and last years
    rectMode(CENTER);
    fill(c1);
    rect(firstPos.x-width*0.045, firstPos.y, width*0.05, height*0.035, 500);
    rect(lastPos.x+width*0.045, lastPos.y, width*0.05, height*0.035, 200);

    textSize(height*0.020);
    textAlign(CENTER, CENTER); //horizontally and vertically
    fill(255);
    text(str(firstYear), firstPos.x-width*0.045, firstPos.y-height*0.002);
    text(str(lastYear), lastPos.x+width*0.045, lastPos.y-height*0.002);
  }

  void update(float posX) {
    float prev = selected; //save previous selected
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
      //check if the selected year has changed
      if (prev != selected) {
        removeEarthquakes();
        loadEarthquakes();
      }
    }
  }
}
