class Projekt {

  PVector pos;
  float rad, giro;
  int per = 0;
  String tit = "Titulo Proyecto";
  String[] ind;

  Projekt(PVector p, float r, int pp, String t, String[] i){
    pos = p;  //Posición PVector
    rad = r;  //Radio
    per = pp; //Cantidad de Personas en el proyecto
    tit = t;  //Nombre proyecto
    ind = i; //Nombre personas
  }

    void circulo(int[] c, int a, int s, int sal, float w) {
    ellipseMode(CENTER);
    if (s == -1) {noStroke();} else {stroke(s,sal); strokeWeight(w);}
    if (c == null) {noFill();} else {fill(c[0],c[1],c[2],a);}
    ellipse(pos.x,pos.y,rad*2,rad*2);
  }

  void ptos(int s2, int f, int a, int s, float c, int ff) {
    float angle = TWO_PI / per;
    for (float t = 0; t < TWO_PI; t += angle) {
      float sx = pos.x + cos(t) * rad;
      float sy = pos.y + sin(t) * rad;
      float tx = pos.x + cos(t) * (rad*ff);
      float ty = pos.y + sin(t) * (rad*ff);
      
      strokeWeight(1/z);

      if (s == -1){noStroke();} else {stroke(s,a);}
      if (f == -1){noFill();} else {fill(f,a);}
	  fill(0);
      ellipse(tx,ty,0.3,0.3);
      fill(255);
      ellipse(tx,ty,0.2,0.2);
    }
  }

  void titulo(int s, int[] c, int a) {
    rectMode(RADIUS);
    textSize(s);
    textLeading(s);
    textAlign(CENTER,CENTER);
    fill(c[0],c[1],c[2],a);
    text(tit, pos.x-(0.75*rad), pos.y-(0.75*rad),rad*1.5,rad*1.5);
    noFill();
  }

  void nombre(int s, int f, int a) {
    rectMode(CENTER);
    textSize(s);
    textLeading(1);
    textAlign(LEFT,CENTER);
    fill(f,a);
    text(tit, pos.x, pos.y,rad*3/4,rad*3/4);
    noFill();
  }
  void num(float x, float y,int s, int f, int a) {
    textSize(3);
    textAlign(CENTER,CENTER);
    fill(f,a);
    text(0, x, y);
    noFill();
  }
}