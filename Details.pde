class Details {
  String deaths, hDamaged, hDestroyed, damage, depth, magnitude;
  String country, day, month, year, hour, minute;
  StringList info;
  PVector center, e1, e2, e3, e4, e5, e6;
  float r1, r2, l, extra, incr; //add increase
  color c;
  float titleSize;
  int opacity, count; //add opacity and count
  //boolean close; //FADE OUT


  Details(TableRow row, color magColor) {

    info  = new StringList();
    
    if (Float.isNaN(row.getFloat("TOTAL_DEATHS"))) { //deaths
      info.append("? ? ?"); //magnitude
    } else {
      info.append(nf(int(row.getFloat("TOTAL_DEATHS")))); 
    }
    
    info.append(nf(row.getInt("TOTAL_HOUSES_DAMAGED"), 1)); //houses damaged
    
    info.append(nf(row.getInt("TOTAL_HOUSES_DESTROYED"), 1)); //houses destroyed
    
    if (Float.isNaN(row.getFloat("TOTAL_DAMAGE_MILLIONS_DOLLARS"))) { //damages
      info.append("? ? ?"); //magnitude
    } else {
      info.append(nf(row.getFloat("TOTAL_DAMAGE_MILLIONS_DOLLARS"), 0, 1)); 
    }
    
    info.append(nf(row.getInt("FOCAL_DEPTH"), 1)); //focal depth
    if (Float.isNaN(row.getFloat("EQ_PRIMARY"))) {
      info.append("? ? ?"); //magnitude
    } else {
      info.append(nf(row.getFloat("EQ_PRIMARY"), 0, 1)); //magnitude
    }

    for (int i = 0; i<info.size()-1; i++) {
      String s = "0";
      if (info.get(i).equals(s)) {
        info.set(i, "? ? ?");
      }
    }

    country = row.getString("COUNTRY");
    year = row.getString("YEAR");
    month = nf(row.getInt("MONTH"), 2);
    day = nf(row.getInt("DAY"), 2);
    hour = nf(row.getInt("HOUR"), 2);
    minute = nf(row.getInt("MINUTE"), 2);

    l = -height*0.28;
    center = new PVector (0, 0);
    e1 = new PVector (0, l);
    e2 = new PVector (0, l);
    e2.rotate(PI/3);
    e3 = new PVector (0, l);
    e3.rotate(TWO_PI/3);
    e4 = new PVector (0, -l);
    e5 = new PVector (0, -l);
    e5.rotate(PI/3);
    e6 = new PVector (0, -l);
    e6.rotate(TWO_PI/3);

    r1 = height*0.14;
    r2 = height*0.10;
    c = magColor;
    titleSize = height*0.035;
    extra = 0;

    //animation
    opacity = 0;
    count = 0;
    incr = width*0.0001;
    //close = true; //FADE OUT
  }

  void display() { 
    //white quad with 60% opacity (153)
    float o = map(opacity, 0, 255, 0, 153); //adapt opacity animation
    fill(255, 255, 255, o);
    noStroke();
    quad(0, 0, width, 0, width, height, 0, height);

    pushMatrix();
    translate(width/2, height/2);

    //ELLIPSES
    ellipseMode(RADIUS);

    dropShadow();
    noStroke();
    fill(c, opacity);//add opacity

    //location and date
    ellipse(center.x, center.y, r1, r1);
    //deaths
    ellipse(e1.x, e1.y, r2, r2);
    //houses damaged
    ellipse(e2.x, e2.y, r2, r2);
    //houses destroyed
    ellipse(e3.x, e3.y, r2, r2);
    //damage
    ellipse(e4.x, e4.y, r2, r2);
    //focal depth
    ellipse(e5.x, e5.y, r2, r2);
    //magnitude
    ellipse(e6.x, e6.y, r2, r2);


    //CENTRAL TEXT
    fill(255, opacity); //add opacity
    textAlign(CENTER, CENTER);

    //country
    checkCountrySize(country);
    textSize(titleSize);
    text(country, center.x, center.y-height*0.05);

    //date and time
    textSize(height*0.025);
    text(day+"/"+month+"/"+year, center.x, center.y+height*0.030+extra);
    text("at "+hour+":"+minute, center.x, center.y+height*0.06+extra);

    //TITLES
    textSize(height*0.020);
    text("Deaths", e1.x, e1.y-height*0.05);
    text("Houses\ndamaged", e2.x, e2.y-height*0.04);
    text("Houses\ndestroyed", e3.x, e3.y-height*0.04);
    text("Damage", e4.x, e4.y-height*0.05);
    text("Focal depth", e5.x, e5.y-height*0.05);
    text("Magnitude", e6.x, e6.y-height*0.05);

    //VALUES
    textSize(height*0.040);
    text(info.get(0), e1.x, e1.y+height*0.005);
    text(info.get(1), e2.x, e2.y+height*0.03);
    text(info.get(2), e3.x, e3.y+height*0.03);
    text(info.get(3), e4.x, e4.y+height*0.005);
    text(info.get(4), e5.x, e5.y+height*0.005);
    text(info.get(5), e6.x, e6.y+height*0.005);

    //SUBTITILES
    textSize(height*0.018);
    text("people", e1.x, e1.y+height*0.04);
    text("millions $", e4.x, e4.y+height*0.04);
    text("0 to 700km", e5.x, e5.y+height*0.04);
    text("0.0 to 9.9", e6.x, e6.y+height*0.04);
    
    /*
    //FADE IN AND FADE OUT
     if(close){
     if (opacity <= 255) {
     opacity+=80;
     }   
     }else{
     fadeOut();
     }*/

    //Only fade in
    if (opacity <= 255) {
      opacity+=80;
    }
    
    //Radius animation
    if (count == 20) {
      incr = -incr;
      count = 0;
    }
    
    r1 += incr;
    r2 += incr;
    count++;

    popMatrix();
  }

  void dropShadow() {
    float aux0 = r1-width*0.004;
    float aux1 = r2-width*0.004;
    float a = width*0.004; //shadow deviation

    for (int i=32; i>=0; i-=2) {
      float o = map(opacity, 0, 255, 0, i); //adapt opacity animation
      fill(180, 180, 180, o);
      noStroke();
      ellipse(center.x+a, center.y+a, aux0, aux0);
      ellipse(e1.x+a, e1.y+a, aux1, aux1);
      ellipse(e2.x+a, e2.y+a, aux1, aux1);
      ellipse(e3.x+a, e3.y+a, aux1, aux1);
      ellipse(e4.x+a, e4.y+a, aux1, aux1);
      ellipse(e5.x+a, e5.y+a, aux1, aux1);
      ellipse(e6.x+a, e6.y+a, aux1, aux1);
      aux0+=aux0*0.01;
      aux1+=aux1*0.01;
    }
  }


  void checkCountrySize(String c) {
    if (c.length() <= 9) {
      titleSize = height*0.035;
    } else if (c.length() > 9 && c.length() <=12) {
      titleSize = height*0.025;
    } else if (c.length() > 12) {
      titleSize = height*0.025;
      country = country.replace(" ", "\n");
      extra = height*0.01;
    }
  }

  /*
  //FADE OUT
   void fadeOut(){
     if (opacity > 0) {
       opacity-=50;
     }else{
       showDetails = false;
     }
   }
   */
}
