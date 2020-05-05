class Details {
  float mag, depth;
  float y, mo, d, h, mi, s;
  float deaths, hDamaged, hDestroyed, damage;
  PVector center, e1, e2, e3, e4, e5, e6;
  float r1, r2, l;
  String country;
  color c;

  Details(TableRow row, color magColor) {
    mag = row.getFloat("EQ_PRIMARY");
    depth = row.getFloat("FOCAL_DEPTH");
    country = row.getString("COUNTRY");
    y = row.getFloat("YEAR");
    mo = row.getFloat("MONTH");
    d = row.getFloat("DAY");
    h = row.getFloat("HOUR");
    mi = row.getFloat("MINUTE");
    s = row.getFloat("SECOND");
    deaths = row.getInt("TOTAL_DEATHS");
    hDamaged = row.getInt("TOTAL_HOUSES_DAMAGED");
    hDestroyed = row.getInt("TOTAL_HOUSES_DESTROYED");
    damage = row.getInt("TOTAL_DAMAGE_MILLIONS_DOLLARS");

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
  }

  void display() { 
    //white quad with 60% opacity
    fill(255, 255, 255, 153);
    noStroke();
    quad(0, 0, width, 0, width, height, 0, height);

    pushMatrix();
    translate(width/2, height/2);
    ellipseMode(RADIUS);
    noStroke();
    fill(c);

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

    popMatrix();
  }
}
